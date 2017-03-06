# Makefile for SliTaz Embedded OS
#

PREFIX?=/usr
DESTDIR?=

all:

# Installation

install:
	install -m 0755 -d $(DESTDIR)/lib
	install -m 0755 -d $(DESTDIR)$(PREFIX)/bin
	install -m 0755 -d $(DESTDIR)$(PREFIX)/share/seb
	install -m 0755 -d $(DESTDIR)$(PREFIX)/share/doc/slitaz
	install -m 0755 -d $(DESTDIR)$(PREFIX)/share/mime/packages
	install -m 0755 libseb.sh $(DESTDIR)/lib
	install -m 0755 seb $(DESTDIR)$(PREFIX)/bin
	cp -rf tools $(DESTDIR)$(PREFIX)/share/seb
	cp -rf initfs $(DESTDIR)$(PREFIX)/share/seb
	cp -rf packages $(DESTDIR)$(PREFIX)/share/seb
	cp -rf README $(DESTDIR)$(PREFIX)/share/doc/slitaz/seb.txt
	cp -rf data/mime/seb.xml $(DESTDIR)$(PREFIX)/share/mime/packages

install-examples:
	install -m 0755 -d $(DESTDIR)$(PREFIX)/share/seb
	cp -rf examples $(DESTDIR)$(PREFIX)/share/seb

# Uninstallation

uninstall:
	rm -f $(DESTDIR)/lib/libseb.sh
	rm -f $(DESTDIR)$(PREFIX)/bin/seb
	rm -rf $(DESTDIR)$(PREFIX)/share/seb

# Clean

clean:
	rm -rf rootfs rootiso sebfs cache
