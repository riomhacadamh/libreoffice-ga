# LibreOffice
# Browse to http://ftp.fsf.hu/LibreOffice/latest-POT/
# grab latest UI zip file e.g.
# wget http://ftp.fsf.hu/LibreOffice/latest-POT/libreoffice-3-4-en-US-2011-07-28-UI.pot.zip
# mv *.zip zipbomb
# cd zipbomb
# unzip *.zip
# rm -f *.zip
# Update the VERSION variable below to the new version number.
# $ make OOo.po-update
# mv -f OOo-3.4.po OOo-latest.ga.po
# git commit OOo-latest.ga.po

############################################################
#    Instructions upon new OOo release
# (1) Update the VERSION variable below to the new milestone number.
# (2)  Then $ make distclean
# (3) Generate POT files; either download directly from Pavel's site:
#  DON'T BOTHER AS OF 2011 - Pavel's files all out of date...
# $ wget ftp://ftp.linux.cz/pub/localization/OpenOffice.org/devel/POT/OpenOffice.org-SRC680_m79-POT.tar.gz
# $ gunzip -c Op*.tar.gz | tar -xf -
# $ rm -f Open*
#
#       ...  OR ...
#
#    Get the latest SDF from OOo and convert to POT:
#  $ wget http://download.services.openoffice.org/files/extended/ooomisc/sdf/DEV300_m104.sdf.bz2
#  $ bunzip2 *.bz2
#  $ mv DEV*.sdf en-US.sdf
#  $ oo2po -P -i en-US.sdf -o pot
#
#
# $ make OOo.po-update
# Then update the
# "CURRENT VERSION" at the top of OOo-SRC680_m79.ga.po, mv -f it to OOo-latest
#   run "mt OOo-latest.ga.po" to translate new strings + minimize CVS diff!
# $ cvs commit OOo-latest.ga.po
#    and give current translation counts, version number in log entry
# $ make   (rebuilds GSI and copies it to obair for Pavel's system)

VERSION=3.4
PO2OO=po2oo

all: libreoffice-$(VERSION)-ga.zip

libreoffice-$(VERSION)-ga.zip: OOo-latest.ga.po
	bash oonua
	zip -r libreoffice-$(VERSION)-ga.zip po/

# defunct now
oldall : libreoffice-$(VERSION)-ga-GSI.sdf
	${HOME}/seal/installed-local/gsicheck/gsicheck -c -l ga libreoffice-$(VERSION)-ga-GSI.sdf
	bzip2 libreoffice-$(VERSION)-ga-GSI.sdf
	cp -f libreoffice-$(VERSION)-ga-GSI.sdf.bz2 ${HOME}/public_html/obair/GSI_ga.sdf.bz2
	bunzip2 libreoffice-$(VERSION)-ga-GSI.sdf.bz2

# defunct now
libreoffice-$(VERSION)-ga-GSI.sdf : OOo-latest.ga.po
	bash oonua
	$(PO2OO) --version
	$(PO2OO) -l ga -t en-US.sdf -i po -o $@
	sed -i '/en-US\t\t/{s/.*/&\n&/; s/\(\n.*\)en-US\t\t/\1ga\t\t/}' $@  # deals with empty msgids in en-US.sdf, which don't make it into POT files even
#	sed -i '/ga\tNóta: /{s/\\</</g; s/\\>/>/g}' $@
#	sed -i '/Invalid Document Signature/d' $@
#	sed -i '$$!N; /Non-Encrypted Streams.*\n.*Non-Encrypted Streams/!P; D' $@

#  Defunct now that Transl toolkit is using msgctxt 
propogate : FORCE
	perl adhoc.pl | msgcat - - > OOo-temp.ga.po
	cpo -q OOo-latest.ga.po
	cpo -q OOo-temp.ga.po
	mv -f OOo-temp.ga.po OOo-latest.ga.po

# once per version bump -- see instructions at the top
OOo.po-update : FORCE
	find zipbomb -name '*.pot' | sort | xargs msgcat -t utf-8 > bigole.pot
	msgmerge -C OOo-latest.ga.po -o TEMP.po /dev/null bigole.pot
	msgcat TEMP.po > OOo-$(VERSION).ga.po
	rm -f bigole.pot TEMP.po
	echo 'Previous:'
	msgfmt --statistics -o /dev/null OOo-latest.ga.po
	echo 'New:'
	msgfmt --statistics -o /dev/null OOo-$(VERSION).ga.po

clean :
	rm -f *-ga-GSI.sdf OOo-latest.po messages.mo OOo-temp.ga.po
	rm -fR po

distclean :
	$(MAKE) clean
	rm -Rf pot
	rm -f en-US.sdf

spell :
	egrep 'msgstr' OOo-latest.ga.po | tr -d '~' | sed 's/^msgstr "\(.*\)"/\1/' | sed 's/$$/./' | gram-ga.pl --litriu --aschod=iso-8859-1 | sort | uniq -c | sort -r -n

FORCE :
