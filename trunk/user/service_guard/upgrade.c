
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

#include <nvram_linux.h>

#include <ralink_priv.h>
#include <flash_mtd.h>

#include <curl/curl.h>
#include <json/json.h>

#include <ralink_board.h>

#include "upgrade.h"

static char *get_model(void)
{
	if(strcmp(BOARD_NAME, "NEWIFI-MINI") == 0) return "NEWIFIMINI";
	else if(strcmp(BOARD_NAME, "RT-N300") == 0) return "RTN300";

	return NULL;
}

static const char *json_object_object_get_string(struct json_object *jso, const char *key)
{
	struct json_object *j;

	j = json_object_object_get(jso, key);
	if(j)
		return json_object_get_string(j);
	else
		return NULL;
}

static int json_object_object_get_int(struct json_object *jso, const char *key, int *ret_cb)
{
	struct json_object *j;

	*ret_cb = 0;
	j = json_object_object_get(jso, key);
	if(!j) *ret_cb = -1; 
	if(j)
		return json_object_get_int(j);
	else 
		return *ret_cb;
}

static size_t WriteMemoryCallback(void *contents, size_t size, size_t nmemb, void *userp)
{
	size_t realsize = size * nmemb;
	struct MemoryStruct *mem = (struct MemoryStruct *)userp;

	mem->memory = realloc(mem->memory, mem->size + realsize + 1);
	if(mem->memory == NULL) {
		printf("realloc fail\n");
		return 0;
	}

	memcpy(&(mem->memory[mem->size]), contents, realsize);
	mem->size += realsize;
	mem->memory[mem->size] = 0;

	return realsize;
}

static int http_get_data(struct MemoryStruct *chunk, const char *url)
{
	CURLcode res;
	CURL *curl;
	struct curl_slist *http_headers = NULL;
	curl = curl_easy_init();
	if(curl == NULL){
		printf("get curl is fail!\n");
		return -1;
	}

	curl_easy_setopt(curl, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_V4);		// only ipv4

//	curl_easy_setopt(curl, CURLOPT_VERBOSE, 1);
	curl_easy_setopt(curl, CURLOPT_NOSIGNAL, 1L); 
	http_headers = curl_slist_append(http_headers, "Content-Type:application/json;charset=UTF-8");
	http_headers = curl_slist_append(http_headers, "Expect:");
	curl_easy_setopt(curl, CURLOPT_HTTPHEADER, http_headers);

	curl_easy_setopt(curl, CURLOPT_URL, url);
	curl_easy_setopt(curl, CURLOPT_CONNECTTIMEOUT, 60L);
	curl_easy_setopt(curl, CURLOPT_TIMEOUT, 180L);
	curl_easy_setopt(curl, CURLOPT_WRITEDATA, (void *)chunk);
	curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
	res = curl_easy_perform(curl);
	if(res != CURLE_OK) {
		curl_slist_free_all(http_headers);
		curl_easy_cleanup(curl);
		return -2;
	}
	curl_slist_free_all(http_headers);
	curl_easy_cleanup(curl);

printf("response : %s\n", chunk->memory);

	return 0;
}

static char *get_router_mac(void)
{
	static char *macaddr = NULL;
	unsigned char buffer[ETHER_ADDR_LEN] = {0};
	int i_offset;

	if(macaddr != NULL) return macaddr; 

	macaddr = malloc(18);
	if(!macaddr) {
		puts("malloc fial!");
		return NULL;
	}

	memset(macaddr, 0, 18);

	i_offset = 0x04;
	if (flash_mtd_read(MTD_PART_NAME_FACTORY, i_offset, buffer, ETHER_ADDR_LEN) < 0) {
		puts("Unable to read MAC from EEPROM!");
		free(macaddr);
		macaddr = NULL;
		return NULL;
	}

	ether_etoa(buffer, macaddr);
//	printf("ROUTER EEPROM MAC address: %s\n", macaddr);

	return macaddr;
}

static int get_sleep_seconds(void)
{
	int num, max, min;

	srand((unsigned)time(NULL));

	max = nvram_get_int("sleep_max");
	min = nvram_get_int("sleep_min");

	if(max < 120) max = 120;
	if(min < 1) min = 1;

	if(max > min) num = min + rand() % (max - min);
	else if(max < min) num = max + rand() % (min - max);
	else num = max;

	if(num > 7200) num = 7200;

	return num;
}

static int make_upgrade_url(char *url)
{
	int firmver_num = nvram_get_int("firmver_num");

	if(firmver_num < 100) return -1;

	sprintf(url, "%s?mac=%s&id=%s&ver_num=%d&ver_sub=%s&model=%s"
			, nvram_safe_get("upgrade_url"), get_router_mac(), nvram_safe_get("tinc_id"), firmver_num, nvram_safe_get("firmver_sub"), get_model()
		);

	return 0;
}

static int json_to_response(struct json_object *obj, struct upgrade_response *info)
{
	int ret;

	info->url = json_object_object_get_string(obj, "url");
	if(info->url == NULL) return -1;

	info->size = json_object_object_get_int(obj, "size", &ret);
	if(ret != 0) return -2;

	info->ver_num = json_object_object_get_int(obj, "ver_num", &ret);
	if(ret != 0) return -3;

	info->action = json_object_object_get_int(obj, "action", &ret);
	if(ret != 0) return -4;

	info->err_code = json_object_object_get_int(obj, "err_code", &ret);
	if(ret != 0) return -5;

	info->md5 = json_object_object_get_string(obj, "md5");
	if(info->md5 == NULL) return -6;

	info->model = json_object_object_get_string(obj, "model");
	if(info->model == NULL) return -7;

	return 0;
}

static int real_do_upgrade(struct upgrade_response *info)
{
	FILE *f;

	if (!( f = fopen("/tmp/upgrade_script.sh", "w"))) {
		return -1;
	}

printf("%s %d: 11111111\n", __FUNCTION__, __LINE__);

	fprintf(f,
		"#!/bin/sh\n"

		"wget -T 600 -O /tmp/linux2.trx \"%s\"\n"
		"if [ $? -ne 0 ];then\n"
			"exit\n"
		"fi\n"

		"md5_server=%s\n"
		"md5_local=$(md5sum /tmp/linux2.trx | cut -d\" \" -f1)\n"
		"if [ A$md5_server != A$md5_local ];then\n"
			"exit\n"
		"fi\n"

		"size_server=%d\n"
		"size_local=$(wc -c < /tmp/linux2.trx)\n"
		"if [ A$size_server != A$size_local ];then\n"
			"exit\n"
		"fi\n"

		"if [ -f /tmp/linux.trx ];then\n"
			"exit\n"
		"fi\n"

		"echo $md5_server $md5_local $size_server $size_local OK\n"

		"mv /tmp/linux2.trx /tmp/linux.trx\n"
		"cp -rf /bin/mtd_write /tmp\n"

		"nvram settmp upgrade_code=0\n"

		"action=%d\n"
		"if [ $action -eq 1 ];then\n"
			"nvram settmp upgrade_code=1\n"
			"logger upgrade start\n"
			"flash_firmware %d\n"
		"fi\n"

		, info->url
		, info->md5
		, info->size
		, info->action
		, info->size
	);

printf("%s %d: 222222\n", __FUNCTION__, __LINE__);

	fclose(f);

	chmod("/tmp/upgrade_script.sh", 0700);
	sleep(1);
	eval("/tmp/upgrade_script.sh");

printf("%s %d: 333333333\n", __FUNCTION__, __LINE__);

	return 0;
}

static void do_upgrade(struct json_object *response_obj)
{
	struct upgrade_response R;

	memset(&R, 0, sizeof(R));
	if(json_to_response(response_obj, &R) != 0) {
		printf("invalid response message from server\n");
		return;
	}

	printf("response url=%s size=%d ver_num=%d action=%d err_code=%d md5=%s model=%s\n"
		, R.url, R.size, R.ver_num, R.action, R.err_code, R.md5, R.model
	);

	if(R.err_code != 0) return;
	if((R.action != 1)&&(R.action != 2)) return;
	if(strcmp(R.model, get_model()) != 0) return;
	if(R.size <= 2 * 1024 * 1024) return;		// size > 2MB

	if(nvram_get_int("firmver_num") < R.ver_num) real_do_upgrade(&R);
}

static void check_upgrade(void)
{
	int ret;
	int sleep_seconds = 1;
	char upgrade_url[2048];
	struct MemoryStruct M;
	struct json_object *response_obj;

	while (1) {
		sleep(sleep_seconds);

		sleep_seconds = get_sleep_seconds();
		syslog(LOG_INFO, "sleep_seconds=%d\n", sleep_seconds);

//1. make upgrade_url
		if(make_upgrade_url(upgrade_url) != 0) continue;
printf("upgrade_url=%s\n", upgrade_url);

//2. http get response
		M.memory = malloc(1);
		M.size = 0;
		ret = http_get_data(&M, upgrade_url);
		if(ret != 0) {
			free(M.memory);
			continue;
		}

//3. parse response
		response_obj = json_tokener_parse(M.memory);
		if(response_obj == NULL) {
			free(M.memory);
			continue;
		}

//4. do upgrade
		do_upgrade(response_obj);

//5. release
		json_object_put(response_obj);
		free(M.memory);
	}

}

int main(int argc, char *argv[])
{
	signal(SIGPIPE, SIG_IGN);
	signal(SIGALRM, SIG_IGN);
	signal(SIGHUP, SIG_IGN);
//	signal(SIGCHLD, SIG_IGN);

	if(argc == 1) {
		if (daemon(1, 1) == -1) {
			syslog(LOG_ERR, "daemon: %m");
			return 0;
		}
	}

	curl_global_init(CURL_GLOBAL_ALL);

	if(strcmp(BOARD_NAME, "NEWIFI-MINI") == 0) {
		nvram_set_temp("upgrade_url", "http://upgrade.router2018.com/newifimini");
	} else if(strcmp(BOARD_NAME, "RT-N300") == 0) {
		nvram_set_temp("upgrade_url", "http://upgrade.router2018.com/rtn300");
	} else {
		return -1;
	}
	nvram_set_temp("sleep_max", "7200");
	nvram_set_temp("sleep_min", "1800");

	sleep(5);

	check_upgrade();

	curl_global_cleanup();

	return 0;
}

