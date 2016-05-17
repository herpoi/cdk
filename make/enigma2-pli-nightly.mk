#
# yaud-enigma2-pli-nightly
#
yaud-enigma2-pli-nightly: yaud-none host_python lirc \
		boot-elf enigma2-pli-nightly release_enigma2
	@TUXBOX_YAUD_CUSTOMIZE@

#
# enigma2-pli-nightly
#
ENIGMA2_DEPS  = bootstrap libncurses libcurl libid3tag libmad libpng libjpeg libgif libfreetype libfribidi libsigc_e2 libreadline
ENIGMA2_DEPS += libexpat libdvbsipp python libxml2_e2 libxslt python_elementtree python_lxml python_zope_interface
ENIGMA2_DEPS += python_twisted python_pyopenssl python_wifi python_imaging python_pyusb python_pycrypto python_pyasn1 python_mechanize python_six
ENIGMA2_DEPS += python_requests python_futures python_singledispatch python_livestreamer python_livestreamersrv
ENIGMA2_DEPS += libdreamdvd tuxtxt32bpp sdparm hotplug_e2 wpa_supplicant wireless_tools minidlna opkg ethtool
ENIGMA2_DEPS += $(MEDIAFW_DEP) $(EXTERNALLCD_DEP)

E_CONFIG_OPTS = --enable-duckbox

if ENABLE_EXTERNALLCD
E_CONFIG_OPTS += --with-graphlcd
endif

if ENABLE_EPLAYER3
E_CONFIG_OPTS_EPLAYER = --enable-libeplayer3
endif

if ENABLE_MEDIAFWGSTREAMER
E_CONFIG_OPTS_GST = --enable-mediafwgstreamer
endif

$(D)/enigma2-pli-nightly.do_prepare: | $(ENIGMA2_DEPS)
	REVISION=""; \
	BRANCH="master"; \
	REPO="https://github.com/herpoi/GraterliaOS-OpenPLi.git"; \
	if [ -e $(sourcedir)/enigma2-owned-by-user ]; then \
		cp -ra $(sourcedir)/enigma2-owned-by-user $(sourcedir)/enigma2-nightly; \
	else \
		rm -rf $(sourcedir)/enigma2-nightly; \
		rm -rf $(sourcedir)/enigma2-nightly.org; \
		[ -d "$(archivedir)/enigma2-pli-nightly.git" ] && \
		(cd $(archivedir)/enigma2-pli-nightly.git; git pull; git checkout "$$BRANCH"; git checkout HEAD; git pull; cd "$(buildprefix)";); \
		[ -d "$(archivedir)/enigma2-pli-nightly.git" ] || \
		git clone -b $$BRANCH $$REPO $(archivedir)/enigma2-pli-nightly.git; \
		cp -ra $(archivedir)/enigma2-pli-nightly.git $(sourcedir)/enigma2-nightly; \
		[ "$$REVISION" == "" ] || (cd $(sourcedir)/enigma2-nightly; git checkout "$$REVISION"; cd "$(buildprefix)";); \
	fi;
	touch $@
	
$(sourcedir)/enigma2-pli-nightly-gsteplayer/config.status:
	cp -ra $(sourcedir)/enigma2-nightly $(sourcedir)/enigma2-nightly-gsteplayer; \
	sed -i 's/xml.string(\"version\", PACKAGE_VERSION);/xml.string(\"version\", PACKAGE_VERSION);\n\t\txml.string(\"GOSversion\", \"enigma2-multiframework-'"$(DATENOW)"'\");/g' $(sourcedir)/enigma2-nightly-gsteplayer/main/bsod.cpp; \
	cd $(sourcedir)/enigma2-nightly-gsteplayer && \
		./autogen.sh && \
		sed -e 's|#!/usr/bin/python|#!$(hostprefix)/bin/python|' -i po/xml2po.py && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--with-libsdl=no \
			--datadir=/usr/local/share \
			--libdir=/usr/lib \
			--bindir=/usr/bin \
			--prefix=/usr \
			--sysconfdir=/etc \
			--with-boxtype=none \
			--with-gstversion=1.0 \
			PKG_CONFIG=$(hostprefix)/bin/$(target)-pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			PY_PATH=$(targetprefix)/usr \
			$(PLATFORM_CPPFLAGS) \
			$(E_CONFIG_OPTS) \
			$(E_CONFIG_OPTS_EPLAYER) \
			$(E_CONFIG_OPTS_GST)
			
$(sourcedir)/enigma2-pli-nightly-gst/config.status:
	cp -ra $(sourcedir)/enigma2-nightly $(sourcedir)/enigma2-nightly-gst; \
	sed -i 's/xml.string(\"version\", PACKAGE_VERSION);/xml.string(\"version\", PACKAGE_VERSION);\n\t\txml.string(\"GOSversion\", \"enigma2-gstreamer-'"$(DATENOW)"'\");/g' $(sourcedir)/enigma2-nightly-gst/main/bsod.cpp; \
	cd $(sourcedir)/enigma2-nightly-gst && \
		./autogen.sh && \
		sed -e 's|#!/usr/bin/python|#!$(hostprefix)/bin/python|' -i po/xml2po.py && \
		$(BUILDENV) \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--with-libsdl=no \
			--datadir=/usr/local/share \
			--libdir=/usr/lib \
			--bindir=/usr/bin \
			--prefix=/usr \
			--sysconfdir=/etc \
			--with-boxtype=none \
			--with-gstversion=1.0 \
			PKG_CONFIG=$(hostprefix)/bin/$(target)-pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			PY_PATH=$(targetprefix)/usr \
			$(PLATFORM_CPPFLAGS) \
			$(E_CONFIG_OPTS) \
			$(E_CONFIG_OPTS_GST)

$(D)/enigma2-pli-nightly-gsteplayer.do_compile: $(sourcedir)/enigma2-pli-nightly-gsteplayer/config.status
	cd $(sourcedir)/enigma2-nightly-gsteplayer && \
		$(MAKE) all
	touch $@

$(D)/enigma2-pli-nightly-gst.do_compile:$(sourcedir)/enigma2-pli-nightly-gst/config.status
	cd $(sourcedir)/enigma2-nightly-gst && \
		$(MAKE) all
	touch $@

$(D)/enigma2-pli-nightly: enigma2-pli-nightly.do_prepare enigma2-pli-nightly-gsteplayer.do_compile enigma2-pli-nightly-gst.do_compile
	$(MAKE) -C $(sourcedir)/enigma2-nightly-gsteplayer install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/bin/enigma2; \
		mv $(targetprefix)/usr/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gstepl; \
	fi
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/local/bin/enigma2; \
		mv $(targetprefix)/usr/local/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gstepl; \
	fi
	$(MAKE) -C $(sourcedir)/enigma2-nightly-gst install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/bin/enigma2; \
		mv $(targetprefix)/usr/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gst; \
	fi
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/local/bin/enigma2; \
		mv $(targetprefix)/usr/local/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gst; \
	fi
	touch $@

enigma2-pli-nightly-clean:
	rm -f $(D)/enigma2-pli-nightly
	rm -f $(D)/enigma2-pli-nightly-gsteplayer.do_compile
	rm -f $(D)/enigma2-pli-nightly-gst.do_compile
	cd $(sourcedir)/enigma2-nightly-gsteplayer && \
		$(MAKE) distclean
	cd $(sourcedir)/enigma2-nightly-gst && \
		$(MAKE) distclean

enigma2-pli-nightly-distclean:
	rm -f $(D)/enigma2-pli-nightly
	rm -f $(D)/enigma2-pli-nightly-gsteplayer.do_compile
	rm -f $(D)/enigma2-pli-nightly-gst.do_compile
	rm -f $(D)/enigma2-pli-nightly.do_prepare
	rm -rf $(sourcedir)/enigma2-nightly
	rm -rf $(sourcedir)/enigma2-nightly-gsteplayer
	rm -rf $(sourcedir)/enigma2-nightly-gst
