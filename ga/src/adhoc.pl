#!/usr/bin/perl

use strict;
use warnings;
use Locale::PO;

# script that loads a "compendium" of OOo translations (in this case
# the previous translated version) and then, when a new msgid has a
# "_: " location marker, strips it out, looks up remainder in compendium
# and fills in translation if found

sub my_warn
{
return 1;
}

my %translations;

my $aref;
{
	local $SIG{__WARN__} = 'my_warn';
	#$aref = Locale::PO->load_file_asarray("OOo-last.ga.po");
	$aref = Locale::PO->load_file_asarray("OOo-latest.ga.po");
}
foreach my $msg (@$aref) {
	my $id = $msg->msgid();
	my $str = $msg->msgstr();
	if (defined($id) && defined($str)) {
		if ($str and $id) {
			if ($str ne '""') {
				$id =~ s/^"_: [^\\]+\\n/"/;
				$translations{$id}=$msg->dequote($str);
			}
		}
	}
}

my $bref;
{
	local $SIG{__WARN__} = 'my_warn';
	$bref = Locale::PO->load_file_asarray("OOo-latest.ga.po");
}
foreach my $msg (@$bref) {
	my $id = $msg->msgid();
	my $str = $msg->msgstr();
	if (defined($id) && defined($str)) {
		if ($str and $id) {
			if ($id =~ m/^"_: / and $str eq '""') {
				my $strip = $id;
				$strip =~ s/^"_: [^\\]+\\n/"/;
				if (exists($translations{$strip})) {
					$msg->msgstr($translations{$strip});
				}
#				else {
#					print STDERR "no trans for $strip\n";
#				}
			}
			print $msg->dump;
		}
	}
}

exit 0;
