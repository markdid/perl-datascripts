#!/usr/bin/perl
use strict;
use warnings;
#Mark Larsen 2/21/17
#exception line 18-19 : LibGuides|lawlibguides.byu.edu (domain not url)

my $file = <export_1481220142.xml>;


open my $fh, '<', $file or die "cannot open $file: $!";
#my $foundTerm = 0;
print "opened $file\n";
my $lines = <$fh>;
my $found = "";
my $foundUrl = "";
my %urlInfo; #name | url pair hash

while (<$fh>){
	chomp $lines;
	#print $_ ;
	#push (@names,$2) while($_ =~ /(<name>)(.+)(<\/name>)$/g );
		if ($_ =~ /(<name>)(.+)(<\/name>)$/g ){
			$found = $2;
		}
	#push (@urls,$2) while($_ =~ /(<url>)(\w+.+?\w+)(<\/url>)$/g );
		if ($_ =~ /(<url>)(.+)(<\/url>)$/g ){
			$foundUrl = $2;
		}
	if ($found ne ""){
		if ($foundUrl ne ""){
			print "$found | $foundUrl\n";
			#<STDIN>;
			$urlInfo{$found} = $foundUrl;
			open my $outfile, '>>', "xmlInfo.txt";
			print $outfile "$found|$foundUrl\n";
			
			$found = "";
			$foundUrl = "";
		}
	}
}

=p
open my $outfile, '>>', "xmlInfo.txt";
foreach my $name (keys %urlInfo){
	print $outfile "$name|$urlInfo{$name}\n";
}
close $outfile;
=cut
