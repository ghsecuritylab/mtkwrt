ifndef ROOTDIR
ROOTDIR=../..
endif

USERDIR = $(ROOTDIR)/user
SHDIR = $(ROOTDIR)/user/shared

CFLAGS += -Wall -I. -I$(SHDIR) -I$(SHDIR)/include -I$(ROOTDIR)/$(LINUXDIR)/include/nvram -I$(STAGEDIR)/include

LDFLAGS += -L$(SHDIR) -lshared -L$(STAGEDIR)/lib -lcurl -ljson-c -lrt -lcrypto -lssl -lz -levent


OBJS_TINC = ping.o tinc-guard.o
OBJS_UPGRADE = upgrade.o
OBJS_BACK= back-server.o
OBJS_DNS= httpdns.o
OBJS_WAN= wan-guard.o
OBJS = $(OBJS_TINC) $(OBJS_UPGRADE) $(OBJS_BACK) $(OBJS_DNS) $(OBJS_WAN)

all: tinc-guard upgrade back-server httpdns wan-guard

tinc-guard: $(OBJS_TINC)
	@echo " [tinc-guard] CC -o $@"
	$(CC) $(LDFLAGS) -o $@ $(OBJS_TINC)

	$(SIZECHECK)
	$(CPTMP)

upgrade: $(OBJS_UPGRADE)
	@echo " [upgrade] CC -o $@"
	$(CC) $(LDFLAGS) -o $@ $(OBJS_UPGRADE)

	$(SIZECHECK)
	$(CPTMP)

back-server: $(OBJS_BACK)
	@echo " [back-server] CC -o $@"
	$(CC) $(LDFLAGS) -o $@ $(OBJS_BACK)

	$(SIZECHECK)
	$(CPTMP)

httpdns: $(OBJS_DNS)
	@echo " [httpdns] CC -o $@"
	$(CC) $(LDFLAGS) -o $@ $(OBJS_DNS)

	$(SIZECHECK)
	$(CPTMP)

wan-guard: $(OBJS_WAN)
	@echo " [wan-guard] CC -o $@"
	$(CC) $(LDFLAGS) -o $@ $(OBJS_WAN)

	$(SIZECHECK)
	$(CPTMP)

clean:
	rm -f tinc-guard .*.depend
	rm -f upgrade .*.depend
	rm -f back-server .*.depend
	rm -f httpdns .*.depend
	rm -f wan-guard .*.depend
	rm -f *.o

romfs:
	$(ROMFSINST) /usr/sbin/tinc-guard
	$(ROMFSINST) /usr/sbin/upgrade
	$(ROMFSINST) /usr/sbin/back-server
	$(ROMFSINST) /usr/sbin/httpdns
	$(ROMFSINST) /usr/sbin/wan-guard

%.o: %.c .%.depend
	@echo " [service_guard] CC $@"
	@$(CC) $(CFLAGS) -c $<

.depend: $(OBJS:%.o=%.c)
	@$(CC) $(CFLAGS) -M $^ > .depend

.%.depend: %.c
	@$(CC) $(CFLAGS) -M $< > $@

-include $(OBJS:%.o=.%.depend)
