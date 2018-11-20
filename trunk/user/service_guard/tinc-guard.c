
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <time.h>
#include <sys/types.h>
#include <sys/sysinfo.h>
#include <sys/stat.h>
#include <stdint.h>
#include <syslog.h>
#include <ctype.h>

#include <sys/syscall.h>

#include <nvram_linux.h>

#include <shutils.h>

#include "ping.h"

volatile int gotuser;

static unsigned int start_seconds, current_seconds, interval_seconds;

static int check_if_file_exist(const char *filepath)
{
	struct stat stat_buf;

	if (!stat(filepath, &stat_buf))
		return S_ISREG(stat_buf.st_mode);
	else
		return 0;
}

static unsigned int monotonic_second(void)
{
	struct timespec ts;
	syscall(SYS_clock_gettime, CLOCK_MONOTONIC, &ts);
	return ts.tv_sec;
}

static void sig_handler(int sig)
{
	switch (sig) {
	case SIGUSR1:
		gotuser = 1;
		break;
	}
DPRINTF("catch sig num=%d\n", sig);
}

int main(int argc, char *argv[])
{
	int tinc_recon_interval;
	int ret, fail_count, ping_count;
	char *ping_host;
	signal(SIGPIPE, SIG_IGN);
	signal(SIGALRM, SIG_IGN);
	signal(SIGHUP, SIG_IGN);
	signal(SIGCHLD, SIG_IGN);
	signal(SIGUSR1, sig_handler);

	if(argc == 1) {
		if (daemon(1, 1) == -1) {
			syslog(LOG_ERR, "daemon: %m");
			return 0;
		}
		ping_host = "172.16.0.1";
	} else {
		ping_host = argv[1];
	}

	start_seconds = monotonic_second();

	sleep(5);

	if(check_if_file_exist("/etc/tinc/gfw/tinc.conf")) {
		eval("restart_fasttinc");
	} else {
		eval("restart_tinc");
	}

	tinc_recon_interval = nvram_get_int("tinc_recon_seconds");
	if(tinc_recon_interval < 300) tinc_recon_interval = 300;
	if(tinc_recon_interval > 864000) tinc_recon_interval = 864000;		// 10 days
	gotuser = 0;
	fail_count = 0;
	while (1) {
		current_seconds = monotonic_second();
DPRINTF("stamps=%u\n", monotonic_second());

		interval_seconds = current_seconds - start_seconds;
		if(interval_seconds > tinc_recon_interval) {
			syslog(LOG_WARNING, "interval_seconds=%u\n", interval_seconds);
			gotuser = 0;
			fail_count = 0;
			start_seconds = current_seconds;
			eval("restart_fasttinc");

			sleep(60);
		}

		if(gotuser == 1) {
			sleep(2);			// wait tincd exit
			if(interval_seconds > 60) {
				gotuser = 0;
				fail_count = 0;
				start_seconds = current_seconds;
				eval("restart_fasttinc");

				sleep(60);
			} else {
				sleep(30);
				continue;
			}
		}

		if(fail_count > 0) ping_count = 2;
		else ping_count = 3;

		sleep(2);
		ret = do_ping(ping_host, ping_count);

		if(ret == 0) fail_count = 0;
		else fail_count++;

		if(fail_count > 1) {
			if(pidof("tinc_start") > 0) sleep(30);

			if(check_if_file_exist("/etc/tinc/gfw/tinc.conf")) {
				eval("restart_fasttinc");
			} else {
				eval("restart_tinc");
			}

			gotuser = 0;
			fail_count = 0;
			start_seconds = current_seconds;

			sleep(60);
		}
	}

	return 0;
}

