site-ffwp
=========

Freifunk Westpfalz - Gluon Konfiguration

------------------------------------------
### Build Schritte

Alle hier genannten Befehle sind im Ordner "site" auszufuehren.

Jede Nacht laeuft ein Erstell-Vorgang (via CRON), der folgendes startet; dabei wird automatisch auch signiert:

    $ ./start-build.sh
        #startet: pull-repos.sh
        #startet: make-release.sh

Eine neue NIGHTLY wird nur erstellt, wenn es entweder einen neuen GLUON Version (Tag) gibt oder wenn sich etwas im SITE Repository geaendert hat.

Will man ein BETA- (oder STABLE-) Release vorbereiten, so ist die aktuelle NIGHTLY (oder BETA) nach .PRE_BETA (oder .PRE_STABLE) zu kopieren.
Dies geschieht mit:

    $ ./copy-to-pre.sh beta   #oder stable

Fuer BETA (oder STABLE) muss danach eine eigene MANIFEST-Datei erzeugt werden.
Dies sollte erst am Tag des Rollouts passieren, da sonst u.U. der Autoupdater direkt ausgefuehrt wird (weil der Wartezeitraum des Updates abgelaufen ist). Folgender Befehl ist manuell auszufuehren:

    $ ./make-manifest.sh beta   #oder stable


Nun ist ein manuelles Signieren notwendig (BETA und STABLE werden nicht automatisch signiert).
Nachdem alle benoetigten Personen geprueft und unterzeichnet haben, kann der Build veroeffentlicht werden.
Dies geschieht durch Kopieren in den dafuer vorgesehen Ordner mithilfe dieses Skripts:

    $ ./release-pre.sh beta  #oder stable

Im Anschluss der Veroeffentlichung bitte
- die Firmware-Dateien zusaetzlich manuell ins Versionsarchiv kopieren (mit einem neuen Ordner gemaess Branch und Version)
- die Versionsnummer in site.mk hochzaehlen
- diese Datei hier anpassen


------------------------------------------
### Versionen (ffwp: gluon)

0.10.2: v2017.1.8
+ Gluon 2017.1.8

0.10.0: v2017.1.7 (180430-2230)
+ Gluon 2017.1.7

0.10.0: v2017.1.6
+ Gluon 2017.1.6
+ statische IPs entfernt

0.9.3: v2017.1.5
+ Targets brcm2708-bcm2708 bzw. brcm2708-bcm2709 ergaenzt (fuer RaspberryPi 1 bzw. 2)

0.9.2: v2017.1.5
+ Target ramips-mt7621 ergaenzt (fuer Ubiquiti EdgeRouter-X und Ubiquiti EdgeRouter-X SFP)

0.9.1: v2017.1.5
+ Gluon 2017.1.5

0.9.0: v2017.1.4
+ Gluon 2017.1.4
+ Fastd zusätzlich ohne Crypto anbieten
+ DNS-Cache
+ Aufräumarbeiten
+ respondd-module-airtime
+ gluon-ebtables-segment-mld
+ gluon-ebtables-source-filter

0.8.2: v2016.2.6
+ Gluon 2016.2.6
+ pull.log mit in output/images Ordner kopieren (zur Doku)

0.8.2: v2016.2.6
+ Gluon 2016.2.6
+ pull.log mit in output/images Ordner kopieren (zur Doku)

0.8.1: v2016.2.5.x
+ Gluon 2016.2.5-6-g97f44c2
+ Packages hinzufuegen
  - ffffm-button-bind (mit einem eigenen Tab im Erweitereten Modus)
  - tecff-ath9k-broken-wifi-workaround
  - tecff-respondd-watchdog
  - ffrn-lowmem-patches
+ Abschaltung von 802.11b
+ Entfernen von gluon-alfred
+ IPv6 Adresse in der Firmware aendern und alte Mirror-URL entfernen
+ einige kleinere Aenderungen an den Build-Scripten
+ Aendern der Versionsnummer auf 0.8.2

0.8.0: v2016.2.5
+ Gluon 2016.2.5

0.7.4: v2016.2.4
+ Gluon 2016.2.4

0.7.3: v2016.2.2
+ Gluon 2016.2.2 (?)

0.7.2: v2016.2.1
+ Gluon 2016.2.1

0.7.1: v2016.2
+ Gluon 2016.2

0.6.2: v2016.1.5
+ Gluon 2016.1.5
+ (intern) zurueckstellen auf offizielles Release v2016.1.5
+ (intern) Umbau auf neue Build-VM (jessi)

0.6.1: v2016.1.x
+ Gluon 2016.1.5-8-gdeac14e
+ (intern) Build-Prozess ging (kurzzeitig) nur ab debian jessi, deshalb auf v2016.1.x gewechselt

0.5.5: v2016.1.3
+ Gluon 2016.1.3
+ (intern) make dirclean 1x vor dem Build Prozess ausfuehren  

0.5.4: v2016.1.2
+ (Autoupdater) https wieder entfernen
+ (intern) Build-Skripte zum Veroeffentlichen

0.5.3: v2016.1.2
+ Gluon 2016.1.2
+ Reboot Text zeigt nun wieder Schluessel
+ (intern) Firmware-Build Skripte ergaenzt um make-manifest
+ (intern) Build-Skripte LOG-Files angepasst

0.5.2: v2016.1.1
+ Gluon 2016.1.1
+ weitere Domain fuer alle Gateways und NTP
+ weitere Domain und https fuer Autoupdater,
  Aenderung der Reihenfolge, so dass Updates zuerst ueber Nameserver gehen

0.5.1: v2016.1
+ Gluon 2016.1
+ Entfernen der Email-Aufforderung beim Einrichten als Mesh-VPN
+ Autoupdater Key fuer Xermon
+ (intern) Firmware-Build Skripte in site aufgenommen

0.5.0:
+ längere Testphase mit master (damaliges pseudo v2015.2)
+ Tests mit 802.11s Parallelbetrieb, aber wieder entfernt
+ ab Februar 2015 erste Builds mit Gluon Release v2016.1
+ Umstellung site.conf/mk auf neues Release

0.4.0: v2015.1.2
+ Gluon 2015.1.2
+ Limit fuer verbundene Gateways auf 1 reduziert (verringert Bandbreite)
+ Anpassung Sprachdatei Englisch
+ HT20 statt HT40+ verwenden (bei 2,4 GHz)
+ neue/geänderte Keys/Ports für Gateways 04 bis 09
+ Autobuilder Key aus BETA und STABLE entfernt, good_signatures entsprechend verringert

0.3.3: v2015.1.1
+ Mesh-VPN im Default wieder einschalten

0.3.2: v2015.1.1
+ Gluon 2015.1.1
+ SSID fuer 5GHz korrigiert (Suffix 5GHz fehlte)

0.3.1: v2015.1
+ MTU Korrektur

0.3.0: v2015.1  (falsche MTU, nicht installieren!)
+ Mehrsprachiger Config Mode (EN DE)
+ Mesh-on-LAN
+ Erweiterte WLAN Konfiguration

0.2.3: v2014.4
+ Autoupdater korrigiert (angeschaltet) im config mode
+ Autoupdate direkt ausfuehren (GLUON_PRIORITY=0)

0.2.2: v2014.4
+ keys-Mail angepasst fuer einfacheres copy & paste in peers-file
+ ipv4 Adresse fuer GW02 wieder entfernt

0.2.1: v2014.4
+ Ergaenzung um alternative ipv4 Adresse fuer GW02, falls DNS ausfaellt

0.2.0: v2014.4
+ neues Gluon Release 2014.4
+ Signatur-Key fuer Zaunei

0.1.4: v2014.3.1
+ URLs geaendert fuer fastd-connection und Autoupdater

0.1.3: v2014.3.1
+ Gateway 02-05 hinzugefuegt, URL GW01 geaendert, Website URL angepasst

0.1.2: v2014.3.1
+ Channel 6, SSID beta entfernt, NTP

0.1.1: v2014.3.1
+ neues Gluon Release 2014.3.1

0.1.0: v2014.3

0.1+0: v2014.3

------------------------------------------
### Liste der Beta-Builds

0.9.3-180308-1100

0.9.0-180125-0005

0.8.2-180107-0036

0.8.1-170523-2140 (2017-05-29)

0.7.4-170315-0032

0.7.3-170107-2300

0.6.1-160601-2333 (2016-07-24)

0.5.5-160403-2131

0.5.2-160304-0022

0.4.0-151015-0115

0.3.3-150707-0130

0.3.2-150629-0130

0.3.1-150618-2325 und 0.3.1-150618-1247

0.3.0-150617-0215

0.2.3-150207-0215

0.2.2-150202-0215

0.2.1-150124-0215

0.2.0-150115-0220

0.1.4-150103-1607

0.1.3-141201-0215

0.1.2-141118-0215

0.1.1-141104-1750

0.1+0-beta20141018-0215

------------------------------------------
### Liste der Stable-Builds

0.9.3-180308-1100 (2018-03-11)

0.8.2-180107-0036 (2018-01-13)

0.7.4-170315-0032 (2017-04-08)

0.6.1-160601-2333 (2016-10-22)

0.5.5-160403-2131 (2016-04-15)

0.4.0-151025-1431 (2015-10-25)

0.3.3-150707-0130 (2015-07-12)

0.2.3-150207-0215 (2015-02-12)

0.1.4-150103-1607 (2015-01-14)
