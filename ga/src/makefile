#    Instructions upon new OOo release
# (1) Update the VERSION variable below to the new milestone number.
# (2)  Then
# $ make distclean
# $ wget ftp://ftp.linux.cz/pub/localization/OpenOffice.org/devel/POT/OpenOffice.org-SRC680_m79-POT.tar.gz
# $ gunzip OpenOffice.org-SRC680_m79-POT.tar.gz
# $ tar xvf OpenOffice.org-SRC680_m79-POT.tar
# $ rm -f OpenOffice.org-SRC680_m79-POT.tar
# $ make OOo.po-update
# Then update the
# "CURRENT VERSION" at the top of OOo-SRC680_m79.ga.po, mv -f it to OOo-latest
# $ tunnel  (in another window)
# $ cvs commit OOo-latest.ga.po
#    and give current translation counts, version number in log entry
# $ make   (rebuilds GSI and copies it to obair for Pavel's system)

VERSION=SRC680_m156

all : OOo-$(VERSION)-ga-GSI.sdf
	bzip2 OOo-$(VERSION)-ga-GSI.sdf
	cp -f OOo-$(VERSION)-ga-GSI.sdf.bz2 ${HOME}/public_html/obair/GSI_ga.sdf.bz2
	bunzip2 OOo-$(VERSION)-ga-GSI.sdf.bz2

# murf: 18 Feb 2005 on dev mailing list:
# create GA locale file and put it in with other locale defs
# configure with --with-lang="es ga"
# 'localize -m -f OOo-$(VERSION)-ga-GSI.sdf -l ga'
# (cd instsetoo_native/util; dmake ooolanguagepack)
#    -- "with the epm patch in place"
#     to create a sh script "language pack" that should be installable
#     on top of a clean English binary install of this snapshot
#   tools->options->language, choose "ga" and restart
OOo-$(VERSION)-ga-GSI.sdf : OOo-latest.po
	bash oonua
	po2oo -l ga -t en-US.sdf -i po -o $@

# this is the compendium to be used to create the finished GSI/SDF,
# obtained by converting to utf-8
# used to do Pofake too, but now this is done in oonua with msgmerge
# Pofake OOo-$(VERSION).ga.po | msgcat - > OOotemp.po
OOo-latest.po : OOo-latest.ga.po
	rm -f $@
	po2utf8 OOo-latest.ga.po > $@
	chmod 400 $@

propogate : FORCE
	perl adhoc.pl | msgcat - - > OOo-temp.ga.po
	cpo -q OOo-latest.ga.po
	cpo -q OOo-temp.ga.po

# once per version bump -- see instructions at the top
# relies on fact that utf-8/non-latin1 msgids are all in helpcontent
#  only latin1/non-ascii are things like "Bézier"
OOo.po-update : FORCE
	find pot -name '*.pot' | egrep -v '^pot/helpcontent2' | sort | xargs msgcat -t utf-8 | iconv -f utf8 -t iso-8859-1 | sed 's/plain; charset=UTF-8/plain; charset=ISO-8859-1/' > bigole.pot
	msgmerge -C OOo-latest.ga.po -o TEMP.po /dev/null bigole.pot
	msgcat TEMP.po > OOo-$(VERSION).ga.po
	rm -f bigole.pot
	echo 'Previous:'
	msgfmt --statistics -o /dev/null OOo-latest.ga.po
	echo 'New:'
	msgfmt --statistics -o /dev/null OOo-$(VERSION).ga.po

clean :
	rm -f OOo-*-ga-GSI.sdf OOo-latest.po messages.mo OOo-temp.ga.po
	rm -fR po

distclean :
	$(MAKE) clean
	rm -Rf pot
	rm -f en-US.sdf

spell :
	egrep 'msgstr' OOo-latest.ga.po | tr -d '~' | sed 's/^msgstr "\(.*\)"/\1/' | sed 's/$$/./' | gram-ga.pl --litriu --aschod=iso-8859-1 | sort | uniq -c | sort -r -n

FORCE :
