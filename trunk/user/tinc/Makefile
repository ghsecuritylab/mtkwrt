SRC_NAME=tinc-1.14pre

CFLAGS += -ffunction-sections -fdata-sections
LDFLAGS += -Wl,--gc-sections

all: config_test
	$(MAKE) -C $(SRC_NAME)

config_test:
	( if [ -f ./config_done ]; then \
		echo "the same configuration"; \
	else \
		make configure && touch config_done; \
	fi )

configure:
	( cd $(SRC_NAME) ; \
	autoreconf -ivf ; \
#	CC=$(CROSS_COMPILE)gcc AR=$(AR) RANLIB=$(RANLIB) LD=$(LD) \
	./configure --host=mipsel-linux --build=$(shell (gcc -dumpmachine)) \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var \
		--with-openssl-include="$(STAGEDIR)/include" \
		--with-openssl-lib="$(STAGEDIR)/lib" \
		--disable-lzo \
		--disable-zlib \
		--disable-curses \
		--disable-readline \
		--host=$(HOST_TARGET) \
		--build=$(HOST_BUILD) ; \
	)

clean:
	if [ -f $(SRC_NAME)/Makefile ] ; then \
		$(MAKE) -C $(SRC_NAME) distclean ; \
	fi ; \
	rm -f config_done

romfs:
	$(ROMFSINST) $(SRC_NAME)/src/tinc /usr/sbin/tinc
	$(ROMFSINST) $(SRC_NAME)/src/tincd /usr/sbin/tincd
#	$(ROMFSINST) /usr/bin/openvpn-cert.sh
