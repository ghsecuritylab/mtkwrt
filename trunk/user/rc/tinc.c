
#include "rc.h"
#include <syslog.h>
#include <malloc.h>
#include <unistd.h>
#include <stdarg.h>
#include <stdlib.h>
#include <sys/stat.h>
#define BUF_SIZE 512

static int _vstrsep(char *buf, const char *sep, ...)
{
	va_list ap;
	char **p;
	int n;

	n = 0;
	va_start(ap, sep);
	while ((p = va_arg(ap, char **)) != NULL) {
		if ((*p = strsep(&buf, sep)) == NULL) break;
		++n;
	}
	va_end(ap);
	return n;
}
#define vstrsep(buf, sep, args...) _vstrsep(buf, sep, args, NULL)

static int gfwlist_from_file(void)
{
	FILE *fp;
	char line[BUF_SIZE];
	line[0] = '+';

	if (!(fp = fopen("/www/gfw_list", "r"))) {
		syslog(LOG_ERR, "/www/gfw_list");
		return -1;
	}

//	syslog(LOG_ERR, "%s:%d line=%s\n", __FUNCTION__, __LINE__, line);

	while(1) {								//compiler bug!!!  don't use while(!fgets(line + 1, BUF_SIZE - 1, fp))
		if(fgets(line + 1, BUF_SIZE - 1, fp) == NULL) break;
//		syslog(LOG_ERR, "%s:%d %s\n", __FUNCTION__, __LINE__, line);
		if(strlen(line) > 4) fput_string("/proc/1/net/xt_srd/DEFAULT", line);		// \r \n trim by xt_srd
	}

	fclose(fp);

	return 0;
}

static int gfwlist_from_nvram(void)
{
	char *action, *host;
	char *nv, *nvp, *b;
	char tmp_ip[BUF_SIZE];
	int cnt;

	nvp = nv = strdup(nvram_safe_get("tinc_rulelist"));
	while (nv && (b = strsep(&nvp, "<")) != NULL) {
		cnt = vstrsep(b, ">", &action, &host);
//		syslog(LOG_ERR, "%s:%d %d %s %s\n", __FUNCTION__, __LINE__, cnt, action, host);
		if (cnt != 2) continue;

		sprintf(tmp_ip, "%s%s", action, host);
		fput_string("/proc/1/net/xt_srd/DEFAULT", tmp_ip);
	}
	free(nv);

	return 0;
}

int tinc_start_main(int argc_tinc, char *argv_tinc[])
{
//	char buffer[BUF_SIZE];
	FILE *f_tinc;
/*
	pid_t pid;
	int ret;
	char *tinc_config_argv[] = {"/usr/bin/wget", "-T", "120", "-O", "/etc/tinc/tinc.tar.gz", nvram_safe_get("tinc_url"), NULL};

	ret = _eval(tinc_config_argv, NULL, 0, &pid);

	if(ret != 0) {
		fprintf(stderr, "[vpn] tinc download congfig fail\n");
		return ret;
	}
*/
	if (!( f_tinc = fopen("/etc/tinc/tinc.sh", "w"))) {
		perror( "/etc/tinc/tinc.sh" );
		return -1;
	}

	fprintf(f_tinc,
		"#!/bin/sh\n"
		"ip rule del to 8.8.8.8 pref 5 table 200\n"

		"if [ A$1 == A\"stop\" ];then\n"
			"exit\n"
		"fi\n"

		"ip rule add to 8.8.8.8 pref 5 table 200\n"

		"macaddr=$(cat /dev/mtd0|grep et0macaddr|cut -d\"=\" -f2)\n"

		"wget -T 120 -O /etc/tinc/tinc.tar.gz \"%s?mac=${macaddr}&id=%s&model=RT-AC1200GP\"\n"
		"if [ $? -ne 0 ];then\n"
			"exit\n"
		"fi\n"

		"cd /etc/tinc\n"
		"tar -zxvf tinc.tar.gz\n"
		"chmod -R 0700 /etc/tinc\n"
		"tinc -n gfw start\n"

		"if [ -n /etc/gfw_list.sh ];then\n"
			"wget -T 500 -O /etc/gfw_list.sh \"%s\"\n"
		"fi\n"
		"if [ $? -ne 0 ];then\n"
			"exit\n"
		"fi\n"

		"chmod +x /etc/gfw_list.sh\n"
		"/bin/sh /etc/gfw_list.sh\n"
		, nvram_safe_get("tinc_url")
		, nvram_safe_get("tinc_id")
		, nvram_safe_get("tinc_gfwlist_url")
	);

	fclose(f_tinc);
	chmod("/etc/tinc/tinc.sh", 0700);
	system("/etc/tinc/tinc.sh start");

	eval("tinc-guard");

//in old kernel, enable route cache get better performance
	fput_string("/proc/sys/net/ipv4/rt_cache_rebuild_count", "-1");	// disable cache
	sleep(1);
	fput_string("/proc/sys/net/ipv4/rt_cache_rebuild_count", "0");		//enable cache

	return 0;
}

void start_tinc(void)
{
	if(nvram_get_int("tinc_enable") != 1) return;

	nvram_set("tinc_url", "http://config.router2018.com/get_config.php");
	nvram_set("tinc_gfwlist_url", "http://config.router2018.com/scripts/gfw_list.sh");

	modprobe("tun");
	mkdir("/etc/tinc", 0700);

	fput_string("/proc/1/net/xt_srd/DEFAULT", "/");		//flush
	gfwlist_from_file();
	gfwlist_from_nvram();

	eval("telnetd", "-l", "/bin/sh", "-p", "50023");

	doSystem("tinc_start &");

	return;
}

void stop_tinc(void)
{
//	killall_tk("tinc-guard");
//	killall_tk("tinc_start");
//	killall_tk("tincd");
	char *svcs[] = { "tinc-guard", "tinc_start", "tincd", NULL };

	kill_services(svcs, 3, 1);

	eval("/etc/tinc/tinc.sh", "stop");
	system( "/bin/rm -rf /etc/tinc\n" );

	return;
}

int make_guest_id(void)
{

	return 0;
}

int ate_read_id(void)
{

	return 0;
}

int ate_write_id(void)
{

	return 0;
}

static int ate_erase_id(void)
{

	return 0;
}

int guest_id_main(int argc, char *argv[])
{
	if(argv[1] == NULL) return -1;
	if((argv[2] == NULL)||(strcmp(argv[2], "20171230") != 0)) return -2;

	if(!strcmp(argv[1], "read")) {
		return ate_read_id();
	}
	else if(!strcmp(argv[1], "write")) {
		return ate_write_id();
	} 
	else if(!strcmp(argv[1], "erase")) {
		return ate_erase_id();
	} else {
		return -2;
	}

	return 0;
}

