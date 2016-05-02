#
# diff helper
#
enigma2-nightly-patch \
neutrino-mp-next-patch \
neutrino-mp-tangos-patch \
neutrino-mp-cst-next-patch \
neutrino-mp-cst-next-max-patch \
libstb-hal-next-patch \
libstb-hal-cst-next-patch :
	cd $(sourcedir) && diff -Nur --exclude-from=$(buildprefix)/scripts/diff-exclude $(subst -patch,,$@).org $(subst -patch,,$@) > $(cvsdir)/$@ ; [ $$? -eq 1 ]

# keeping all patches together in one file
# uncomment if needed
#
# Neutrino MP from github
NEUTRINO_MP_LIBSTB_CST_NEXT_PATCHES +=
NEUTRINO_MP_CST_NEXT_PATCHES +=

# Neutrino MP Next from github
NEUTRINO_MP_LIBSTB_NEXT_PATCHES +=
NEUTRINO_MP_NEXT_PATCHES +=

# Neutrino MP Tango
NEUTRINO_MP_TANGOS_PATCHES +=

# Neutrino HD2
NEUTRINO_HD2_PATCHES +=
NEUTRINO_HD2_PLUGINS_PATCHES +=

# lcd4linux
LCD4LINUX_PATCHES +=

