SRC_NAME=json-c-0.11

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
	./autogen.sh && \
	./configure \
		--prefix=$(STAGEDIR) \
		--enable-static \
		--enable-shared \
		ac_cv_func_realloc_0_nonnull=yes ac_cv_func_malloc_0_nonnull=yes \
		--host=$(HOST_TARGET) \
		--build=$(HOST_BUILD) ; \
	)

clean:
	if [ -f $(SRC_NAME)/Makefile ] ; then \
		$(MAKE) -C $(SRC_NAME) distclean ; \
	fi ; \
	rm -f config_done

install:
	$(MAKE) -C $(SRC_NAME) install DESTDIR=""
#	$(MAKE) -C $(SRC_NAME) install DESTDIR="$(STAGEDIR)"

romfs:
	cp -fP $(DESTDIR)/lib/libjson-c.so* $(ROMFSDIR)/lib

