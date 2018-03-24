ifndef ROOTDIR
ROOTDIR=../..
endif

USERDIR = $(ROOTDIR)/user
SHDIR = $(ROOTDIR)/user/shared

CFLAGS += -Wall -I. -I$(SHDIR) -I$(SHDIR)/include -I$(ROOTDIR)/$(LINUXDIR)/include/nvram

LDFLAGS += -L$(SHDIR) -lshared


OBJS_TINC = tinc-guard.o
OBJS = $(OBJS_TINC)

all: tinc-guard

tinc-guard: $(OBJS_TINC)
	@echo " [tinc-guard] CC -o $@"
	$(CC) $(LDFLAGS) -o $@ $(OBJS_TINC)

	$(SIZECHECK)
	$(CPTMP)

clean:
	rm -f tinc-guard .*.depend
	rm -f *.o

romfs:
	$(ROMFSINST) /usr/sbin/tinc-guard


%.o: %.c .%.depend
	@echo " [service_guard] CC $@"
	@$(CC) $(CFLAGS) -c $<

.depend: $(OBJS:%.o=%.c)
	@$(CC) $(CFLAGS) -M $^ > .depend

.%.depend: %.c
	@$(CC) $(CFLAGS) -M $< > $@

-include $(OBJS:%.o=.%.depend)
