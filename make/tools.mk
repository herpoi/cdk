#
# tools
#
tools-clean:
	-$(MAKE) -C $(appsdir)/tools distclean

$(appsdir)/tools/config.status: bootstrap driver bzip2 libpng libjpeg ffmpeg
	cd $(appsdir)/tools && \
	$(CONFIGURE) \
	--prefix=$(targetprefix)/usr \
	--with-boxtype=$(BOXTYPE) \
	$(if $(MULTICOM324), --enable-multicom324) \
	$(if $(MULTICOM406), --enable-multicom406) \
	$(if $(EPLAYER3), --enable-eplayer3)

$(D)/tools: $(appsdir)/tools/config.status
	$(MAKE) -C $(appsdir)/tools all prefix=$(targetprefix) DRIVER_TOPDIR=$(driverdir) \
	CPPFLAGS="\
	-I$(targetprefix)/usr/include \
	-I$(driverdir)/bpamem \
	-I$(driverdir)/include/multicom \
	-I$(driverdir)/multicom/mme \
	-I$(driverdir)/include/player2 \
	$(if $(PLAYER191), -DPLAYER191) \
	" && \
	$(MAKE) -C $(appsdir)/tools install prefix=$(targetprefix) DRIVER_TOPDIR=$(driverdir)
	touch $@

