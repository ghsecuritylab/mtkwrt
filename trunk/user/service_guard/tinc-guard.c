
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

#include <shutils.h>

#include "ping.h"

static int check_if_file_exist(const char *filepath)
{
	struct stat stat_buf;

	if (!stat(filepath, &stat_buf))
		return S_ISREG(stat_buf.st_mode);
	else
		return 0;
}

int main(int argc, char *argv[])
{
	int ret, fail_count, ping_count;
	char *ping_host;
	signal(SIGPIPE, SIG_IGN);
	signal(SIGALRM, SIG_IGN);
	signal(SIGHUP, SIG_IGN);
//	signal(SIGCHLD, chld_reap);

//printf("%d\n", argc);

	if(argc == 1) {
		if (daemon(1, 1) == -1) {
			syslog(LOG_ERR, "daemon: %m");
			return 0;
		}
		ping_host = "172.16.0.1";
	} else {
		ping_host = argv[1];
	}

	sleep(10);

	fail_count = 0;
	while (1) {
		sleep(3);
		if(fail_count > 0) ping_count = 4;
		else ping_count = 6;

		ret = do_ping(ping_host, ping_count);

		if(ret == 0) fail_count = 0;
		else fail_count++;

		if(fail_count > 1) {
			if(check_if_file_exist("/etc/tinc/gfw/tinc.conf")) {
				eval("restart_fasttinc");
			} else {
				eval("restart_tinc");
			}

			sleep(30);
		}
	}

	return 0;
}

