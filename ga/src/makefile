#    Instructions upon new OOo release
# get tarball with the latest POT files and latest en-US.rdf,
# and update the PREVIOUS/VERSION variables below.
#
# $ rm -Rf pot en-US.sdf
# $ wget ftp://ftp.linux.cz/pub/localization/OpenOffice.org/devel/POT/OpenOffice.org-SRC680_m79-POT.tar.gz
# $ gunzip OpenOffice.org-SRC680_m79-POT.tar.gz
# $ tar xvf OpenOffice.org-SRC680_m79-POT.tar
# $ rm -f OpenOffice.org-SRC680_m79-POT.tar
# $ make OOo.po-update
#   correct utf-8 msgids to iso-8859-1...  BÃ.zier, etc.

PREVIOUS=1.1.3-0
VERSION=SRC680_m79

all : OOo-$(VERSION)-ga-GSI.sdf

# murf: 18 Feb 2005 on dev mailing list:
# create GA locale file and put it in with other locale defs
# configure with --with-lang="es ga"
# 'localize -m -f OOo-$(VERSION)-ga-GSI.sdf -l ga'
# (cd instsetoo_native/util; dmake ooolanguagepack)
#    -- "with the epm patch in place"
#     to create a sh script "language pack" that should be installable
#     on top of a clean English binary install of this snapshot
#   tools->options->language, choose "ga" and restart
OOo-$(VERSION)-ga-GSI.sdf : OOo-$(VERSION).po
	bash oonua $(VERSION)
	po2oo -l ga -t en-US.sdf -i po -o $@

# this is the compendium to be used to create the finished GSI/SDF,
# obtained by converting to utf-8
# used to do Pofake too, but now this is done in oonua with msgmerge
# Pofake OOo-$(VERSION).ga.po | msgcat - > OOotemp.po
OOo-$(VERSION).po : OOo-$(VERSION).ga.po
	rm -f $@
	cp -f OOo-$(VERSION).ga.po OOotemp.po
	iconv -f iso-8859-1 -t utf-8 OOotemp.po > $@
	chmod 400 $@
	rm -f OOotemp.po

# once per version bump -- see instructions at the top
# relies on fact that utf-8/non-latin1 msgids are all in helpcontent
#  only latin1/non-ascii are things like "Bézier"
OOo.po-update : FORCE
	find pot -name '*.pot' | egrep -v '^pot/helpcontent2' | xargs msgcat -t utf-8 | iconv -f utf8 -t iso-8859-1 | sed 's/plain; charset=UTF-8/plain; charset=ISO-8859-1/' > bigole.pot
	msgmerge -N -C OOo-$(PREVIOUS).ga.po -o OOo-$(VERSION).ga.po /dev/null bigole.pot
	rm -f bigole.pot ${HOME}/gaeilge/gnu/gnu/OOo-2.0.ga.po
	ln -s  OOo-$(VERSION).ga.po ${HOME}/gaeilge/gnu/gnu/OOo-2.0.ga.po
	echo 'Previous:'
	msgfmt --statistics -o /dev/null OOo-$(PREVIOUS).ga.po
	echo 'New:'
	msgfmt --statistics -o /dev/null OOo-$(VERSION).ga.po

clean :
	rm -f OOo-*-ga-GSI.sdf OOo-$(VERSION).po messages.mo
	rm -fR po

FORCE :
