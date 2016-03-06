#
# yaud-enigma2-pli-nightly
#
yaud-enigma2-pli-nightly: yaud-none host_python lirc \
		boot-elf enigma2-pli-nightly-gst-debug enigma2-pli-nightly-gstepl-debug \
		enigma2-pli-nightly-gst-nodebug enigma2-pli-nightly-gstepl-nodebug enigma2-plugins release_enigma2
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-enigma2-pli-nightly-gst-debug: yaud-none host_python lirc \
		boot-elf enigma2-pli-nightly-gst-debug enigma2-plugins release_enigma2
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-enigma2-pli-nightly-gstepl-debug: yaud-none host_python lirc \
		boot-elf enigma2-pli-nightly-gstepl-debug enigma2-plugins release_enigma2
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-enigma2-pli-nightly-gst-nodebug: yaud-none host_python lirc \
		boot-elf enigma2-pli-nightly-gst-nodebug enigma2-plugins release_enigma2
	@TUXBOX_YAUD_CUSTOMIZE@

yaud-enigma2-pli-nightly-gstepl-nodebug: yaud-none host_python lirc \
		boot-elf enigma2-pli-nightly-nogstepl-debug enigma2-plugins release_enigma2
	@TUXBOX_YAUD_CUSTOMIZE@
	
yaud-enigma2-pli-nightly-recompile: release-enigma2-clean yaud-none host_python lirc \
	boot-elf enigma2-pli-nightly-prepare-recompile-gst-debug enigma2-pli-nightly-prepare-recompile-gstepl-debug \
	enigma2-pli-nightly-prepare-recompile-gst-nodebug enigma2-pli-nightly-prepare-recompile-gstepl-nodebug enigma2-plugins release_enigma2
    @TUXBOX_YAUD_CUSTOMIZE@

yaud-enigma2-pli-nightly-gst-debug-recompile: release-enigma2-clean yaud-none host_python lirc \
	boot-elf enigma2-pli-nightly-prepare-recompile-gst-debug enigma2-plugins release_enigma2
    @TUXBOX_YAUD_CUSTOMIZE@

yaud-enigma2-pli-nightly-gstepl-debug-recompile: release-enigma2-clean yaud-none host_python lirc \
	boot-elf enigma2-pli-nightly-prepare-recompile-gstepl-debug enigma2-plugins release_enigma2
    @TUXBOX_YAUD_CUSTOMIZE@

yaud-enigma2-pli-nightly-gst-nodebug-recompile: release-enigma2-clean yaud-none host_python lirc \
	boot-elf enigma2-pli-nightly-prepare-recompile-gst-nodebug enigma2-plugins release_enigma2
    @TUXBOX_YAUD_CUSTOMIZE@

yaud-enigma2-pli-nightly-gstepl-nodebug-recompile: release-enigma2-clean yaud-none host_python lirc \
	boot-elf enigma2-pli-nightly-prepare-recompile-gstepl-nodebug enigma2-plugins release_enigma2
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

DATENOW=`date +%Y-%m-%d`

$(D)/enigma2-pli-nightly.do_prepare: | $(ENIGMA2_DEPS)
	REVISION=""; \
	BRANCH="trunk"; \
	REPO="https://github.com/herpoi/GraterliaOS-OpenPLi.git"; \
	rm -rf $(sourcedir)/enigma2-nightly; \
	rm -rf $(sourcedir)/enigma2-nightly.org; \
	[ -d "$(archivedir)/enigma2-pli-nightly.git" ] && \
	(cd $(archivedir)/enigma2-pli-nightly.git; git pull; git checkout "$$BRANCH"; git checkout HEAD; git pull; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/enigma2-pli-nightly.git" ] || \
	git clone -b $$BRANCH $$REPO $(archivedir)/enigma2-pli-nightly.git; \
	cp -ra $(archivedir)/enigma2-pli-nightly.git $(sourcedir)/enigma2-nightly; \
	[ "$$REVISION" == "" ] || (cd $(sourcedir)/enigma2-nightly; git checkout "$$REVISION"; cd "$(buildprefix)";); \
	touch $@
	
$(sourcedir)/enigma2-pli-nightly-gstepl/config.status:
	cp -ra $(sourcedir)/enigma2-nightly $(sourcedir)/enigma2-nightly-gstepl; \
	sed -i 's/\"OpenPLi Enigma2 crash log\\n\\n\"/\"OpenPLi Enigma2 crash log\\n\\n\"\n\t\t\t\"GOS Version: enigma2-multiframework-'"$(DATENOW)"'\\n\"/g' $(sourcedir)/enigma2-nightly-gstepl/main/bsod.cpp; \
	sed -i 's/\" - Branch: \"/\"-debug - Branch: \"/g' $(sourcedir)/enigma2-nightly-gstepl/main/version_info.cpp; \
	cd $(sourcedir)/enigma2-nightly-gstepl && \
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

$(sourcedir)/enigma2-pli-nightly-gstepl-nodebug/config.status:
	cp -ra $(sourcedir)/enigma2-nightly $(sourcedir)/enigma2-nightly-gstepl-nodebug; \
	sed -i 's/\"OpenPLi Enigma2 crash log\\n\\n\"/\"OpenPLi Enigma2 crash log\\n\\n\"\n\t\t\t\"GOS Version: enigma2-multiframework-'"$(DATENOW)"'\\n\"/g' $(sourcedir)/enigma2-nightly-gstepl-nodebug/main/bsod.cpp; \
	sed -i 's/\" - Branch: \"/\"-nodebug - Branch: \"/g' $(sourcedir)/enigma2-nightly-gstepl-nodebug/main/version_info.cpp; \
	cd $(sourcedir)/enigma2-nightly-gstepl-nodebug && \
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
			--without-debug \
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
	sed -i 's/\"OpenPLi Enigma2 crash log\\n\\n\"/\"OpenPLi Enigma2 crash log\\n\\n\"\n\t\t\t\"GOS Version: enigma2-gstreamer-'"$(DATENOW)"'\\n\"/g' $(sourcedir)/enigma2-nightly-gst/main/bsod.cpp; \
	sed -i 's/\" - Branch: \"/\"-debug - Branch: \"/g' $(sourcedir)/enigma2-nightly-gst/main/version_info.cpp; \
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

$(sourcedir)/enigma2-pli-nightly-gst-nodebug/config.status:
	cp -ra $(sourcedir)/enigma2-nightly $(sourcedir)/enigma2-nightly-gst-nodebug; \
	sed -i 's/\"OpenPLi Enigma2 crash log\\n\\n\"/\"OpenPLi Enigma2 crash log\\n\\n\"\n\t\t\t\"GOS Version: enigma2-gstreamer-'"$(DATENOW)"'\\n\"/g' $(sourcedir)/enigma2-nightly-gst-nodebug/main/bsod.cpp; \
	sed -i 's/\" - Branch: \"/\"-nodebug - Branch: \"/g' $(sourcedir)/enigma2-nightly-gst-nodebug/main/version_info.cpp; \
	cd $(sourcedir)/enigma2-nightly-gst-nodebug && \
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
			--without-debug \
			--with-boxtype=none \
			--with-gstversion=1.0 \
			PKG_CONFIG=$(hostprefix)/bin/$(target)-pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			PY_PATH=$(targetprefix)/usr \
			$(PLATFORM_CPPFLAGS) \
			$(E_CONFIG_OPTS) \
			$(E_CONFIG_OPTS_GST)
			
$(D)/enigma2-pli-nightly-gstepl.do_compile: $(sourcedir)/enigma2-pli-nightly-gstepl/config.status
	cd $(sourcedir)/enigma2-nightly-gstepl && \
		$(MAKE) all
	touch $@

$(D)/enigma2-pli-nightly-gstepl-nodebug.do_compile: $(sourcedir)/enigma2-pli-nightly-gstepl-nodebug/config.status
	cd $(sourcedir)/enigma2-nightly-gstepl-nodebug && \
		$(MAKE) all
	touch $@
	
$(D)/enigma2-pli-nightly-gst.do_compile:$(sourcedir)/enigma2-pli-nightly-gst/config.status
	cd $(sourcedir)/enigma2-nightly-gst && \
		$(MAKE) all
	touch $@

$(D)/enigma2-pli-nightly-gst-nodebug.do_compile:$(sourcedir)/enigma2-pli-nightly-gst-nodebug/config.status
	cd $(sourcedir)/enigma2-nightly-gst-nodebug && \
		$(MAKE) all
	touch $@
	
$(D)/enigma2-pli-nightly-gst-debug: enigma2-pli-nightly.do_prepare enigma2-pli-nightly-gst.do_compile
	$(MAKE) -C $(sourcedir)/enigma2-nightly-gst install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/bin/enigma2; \
		mv $(targetprefix)/usr/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gst-debug; \
	fi
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/local/bin/enigma2; \
		mv $(targetprefix)/usr/local/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gst-debug; \
	fi
	touch $@

$(D)/enigma2-pli-nightly-gstepl-debug: enigma2-pli-nightly.do_prepare enigma2-pli-nightly-gstepl.do_compile
	$(MAKE) -C $(sourcedir)/enigma2-nightly-gstepl install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/bin/enigma2; \
		mv $(targetprefix)/usr/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gstepl-debug; \
	fi
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/local/bin/enigma2; \
		mv $(targetprefix)/usr/local/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gstepl-debug; \
	fi
	touch $@
	
$(D)/enigma2-pli-nightly-gst-nodebug: enigma2-pli-nightly.do_prepare enigma2-pli-nightly-gst-nodebug.do_compile
	$(MAKE) -C $(sourcedir)/enigma2-nightly-gst-nodebug install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/bin/enigma2; \
		mv $(targetprefix)/usr/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gst-nodebug; \
	fi
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/local/bin/enigma2; \
		mv $(targetprefix)/usr/local/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gst-nodebug; \
	fi
	touch $@

$(D)/enigma2-pli-nightly-gstepl-nodebug: enigma2-pli-nightly.do_prepare enigma2-pli-nightly-gstepl-nodebug.do_compile
	$(MAKE) -C $(sourcedir)/enigma2-nightly-gstepl-nodebug install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/bin/enigma2; \
		mv $(targetprefix)/usr/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gstepl-nodebug; \
	fi
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/local/bin/enigma2; \
		mv $(targetprefix)/usr/local/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gstepl-nodebug; \
	fi
	touch $@

$(D)/enigma2-pli-nightly-prepare-recompile-gst-debug: enigma2-pli-nightly-gst.do_compile
	$(MAKE) -C $(sourcedir)/enigma2-nightly-gst install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/bin/enigma2; \
		mv $(targetprefix)/usr/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gst-debug; \
	fi
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/local/bin/enigma2; \
		mv $(targetprefix)/usr/local/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gst-debug; \
	fi
	touch $@

$(D)/enigma2-pli-nightly-prepare-recompile-gstepl-debug: enigma2-pli-nightly-gstepl.do_compile
	$(MAKE) -C $(sourcedir)/enigma2-nightly-gstepl install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/bin/enigma2; \
		mv $(targetprefix)/usr/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gstepl-debug; \
	fi
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/local/bin/enigma2; \
		mv $(targetprefix)/usr/local/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gstepl-debug; \
	fi
	touch $@

$(D)/enigma2-pli-nightly-prepare-recompile-gst-nodebug: enigma2-pli-nightly-gst-nodebug.do_compile
	$(MAKE) -C $(sourcedir)/enigma2-nightly-gst-nodebug install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/bin/enigma2; \
		mv $(targetprefix)/usr/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gst-nodebug; \
	fi
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/local/bin/enigma2; \
		mv $(targetprefix)/usr/local/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gst-nodebug; \
	fi
	touch $@
	
$(D)/enigma2-pli-nightly-prepare-recompile-gstepl-nodebug: enigma2-pli-nightly-gstepl-nodebug.do_compile
	$(MAKE) -C $(sourcedir)/enigma2-nightly-gstepl-nodebug install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/bin/enigma2; \
		mv $(targetprefix)/usr/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gstepl-nodebug; \
	fi
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/local/bin/enigma2; \
		mv $(targetprefix)/usr/local/bin/enigma2 $(targetprefix)/usr/bin/enigma2-gstepl-nodebug; \
	fi
	touch $@

enigma2-pli-nightly-clean:
	rm -f $(D)/enigma2-pli-nightly
	rm -f $(D)/enigma2-pli-nightly-gstepl.do_compile
	rm -f $(D)/enigma2-pli-nightly-gst.do_compile
	rm -f $(D)/enigma2-pli-nightly-gstepl-nodebug.do_compile
	rm -f $(D)/enigma2-pli-nightly-gst-nodebug.do_compile
	cd $(sourcedir)/enigma2-nightly-gstepl && \
		$(MAKE) distclean
	cd $(sourcedir)/enigma2-nightly-gst && \
		$(MAKE) distclean
	cd $(sourcedir)/enigma2-nightly-gstepl-nodebug && \
		$(MAKE) distclean
	cd $(sourcedir)/enigma2-nightly-gst-nodebug && \
		$(MAKE) distclean

enigma2-pli-nightly-distclean:
	rm -f $(D)/enigma2-pli-nightly
	rm -f $(D)/enigma2-pli-nightly-gstepl.do_compile
	rm -f $(D)/enigma2-pli-nightly-gst.do_compile
	rm -f $(D)/enigma2-pli-nightly-gstepl-nodebug.do_compile
	rm -f $(D)/enigma2-pli-nightly-gst-nodebug.do_compile
	rm -f $(D)/enigma2-pli-nightly.do_prepare
	rm -rf $(sourcedir)/enigma2-nightly
	rm -rf $(sourcedir)/enigma2-nightly-gstepl
	rm -rf $(sourcedir)/enigma2-nightly-gst
	rm -rf $(sourcedir)/enigma2-nightly-gstepl-nodebug
	rm -rf $(sourcedir)/enigma2-nightly-gst-nodebug
	
enigma2-pli-nightly-remake:
	make enigma2-pli-nightly-distclean
	make yaud-enigma2-pli-nightly

enigma2-pli-nightly-gst-debug-remake:
	make enigma2-pli-nightly-distclean
	make yaud-enigma2-pli-nightly-gst-debug

enigma2-pli-nightly-gstepl-debug-remake:
	make enigma2-pli-nightly-distclean
	make yaud-enigma2-pli-nightly-gstepl-debug

enigma2-pli-nightly-gst-nodebug-remake:
	make enigma2-pli-nightly-distclean
	make yaud-enigma2-pli-nightly-gst-nodebug

enigma2-pli-nightly-gstepl-nodebug-remake:
	make enigma2-pli-nightly-distclean
	make yaud-enigma2-pli-nightly-gstepl-nodebug
	
enigma2-pli-nightly-recompile:
	rm -f $(D)/enigma2-pli-nightly
	rm -f $(D)/enigma2-pli-nightly-gstepl.do_compile
	rm -f $(D)/enigma2-pli-nightly-gst.do_compile
	rm -f $(D)/enigma2-pli-nightly-gstepl-nodebug.do_compile
	rm -f $(D)/enigma2-pli-nightly-gst-nodebug.do_compile
	rm -f $(D)/enigma2-pli-nightly.do_prepare
	rm -rf $(sourcedir)/enigma2-nightly-gstepl
	rm -rf $(sourcedir)/enigma2-nightly-gst
	rm -rf $(sourcedir)/enigma2-nightly-gstepl-nodebug
	rm -rf $(sourcedir)/enigma2-nightly-gst-nodebug
	make yaud-enigma2-pli-nightly-recompile

enigma2-pli-nightly-gst-debug-recompile:
	rm -f $(D)/enigma2-pli-nightly
	rm -f $(D)/enigma2-pli-nightly-gst.do_compile
	rm -f $(D)/enigma2-pli-nightly.do_prepare
	rm -rf $(sourcedir)/enigma2-nightly-gst
	make yaud-enigma2-pli-nightly-gst-debug-recompile

enigma2-pli-nightly-gstepl-debug-recompile:
	rm -f $(D)/enigma2-pli-nightly
	rm -f $(D)/enigma2-pli-nightly-gstepl.do_compile
	rm -f $(D)/enigma2-pli-nightly.do_prepare
	rm -rf $(sourcedir)/enigma2-nightly-gstepl
	make yaud-enigma2-pli-nightly-gstepl-debug-recompile

enigma2-pli-nightly-gst-nodebug-recompile:
	rm -f $(D)/enigma2-pli-nightly
	rm -f $(D)/enigma2-pli-nightly-gst-nodebug.do_compile
	rm -f $(D)/enigma2-pli-nightly.do_prepare
	rm -rf $(sourcedir)/enigma2-nightly-gst-nodebug
	make yaud-enigma2-pli-nightly-gst-nodebug-recompile

enigma2-pli-nightly-gstepl-nodebug-recompile:
	rm -f $(D)/enigma2-pli-nightly
	rm -f $(D)/enigma2-pli-nightly-gstepl-nodebug.do_compile
	rm -f $(D)/enigma2-pli-nightly.do_prepare
	rm -rf $(sourcedir)/enigma2-nightly-gstepl-nodebug
	make yaud-enigma2-pli-nightly-gstepl-nodebug-recompile