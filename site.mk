GLUON_SITE_PACKAGES := \
	gluon-mesh-batman-adv-14 \
	gluon-alfred \
	gluon-announce \
	gluon-announced \
	gluon-autoupdater \
	gluon-cron \
	gluon-ebtables-filter-multicast \
	gluon-ebtables-filter-ra-dhcp \
	gluon-config-mode-autoupdater \
	gluon-config-mode-hostname \
	gluon-config-mode-mesh-vpn \
	gluon-config-mode-geo-location \
	gluon-config-mode-contact-info \
	gluon-luci-admin \
	gluon-luci-autoupdater \
	gluon-luci-portconfig \
	gluon-luci-private-wifi \
	gluon-neighbour-info \
	gluon-next-node \
	gluon-mesh-vpn-fastd \
	gluon-radvd \
	gluon-status-page \
	iwinfo \
	iptables \
	haveged

DEFAULT_GLUON_RELEASE := 0.2.3-$(shell date '+%y%m%d-%H%M')
DEFAULT_GLUON_PRIORITY := 0

# Allow overriding the release number from the command line
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)

# Default priority for updates.
GLUON_PRIORITY ?= $(DEFAULT_GLUON_PRIORITY)
