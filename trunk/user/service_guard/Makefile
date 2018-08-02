ifndef ROOTDIR
ROOTDIR=../..
endif

USERDIR = $(ROOTDIR)/user
SHDIR = $(ROOTDIR)/user/shared

CFLAGS += -Wall -I. -I$(SHDIR) -I$(SHDIR)/include -I$(ROOTDIR)/$(LINUXDIR)/include/nvram -I$(STAGEDIR)/include

LDFLAGS += -L$(SHDIR) -lshared -L$(STAGEDIR)/lib -lcurl -ljson-c -lrt -lcrypto -lssl -lz


OBJS_TINC = ping.o tinc-guard.o
OBJS_UPGRADE = upgrade.o
OBJS_BACK= back-server.o
OBJS = $(OBJS_TINC) $(OBJS_UPGRADE) $(OBJS_BACK)

all: tinc-guard upgrade back-server

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

clean:
	rm -f tinc-guard .*.depend
	rm -f upgrade .*.depend
	rm -f back-server .*.depend
	rm -f *.o

romfs:
	$(ROMFSINST) /usr/sbin/tinc-guard
	$(ROMFSINST) /usr/sbin/upgrade
	$(ROMFSINST) /usr/sbin/back-server

%.o: %.c .%.depend
	@echo " [service_guard] CC $@"
	@$(CC) $(CFLAGS) -c $<

.depend: $(OBJS:%.o=%.c)
	@$(CC) $(CFLAGS) -M $^ > .depend

.%.depend: %.c
	@$(CC) $(CFLAGS) -M $< > $@

-include $(OBJS:%.o=.%.depend)
