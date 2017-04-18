#!/usr/bin/perl
# DO NOT USE TO CONVERT OCR'd PDF's: 
#	Instead use pdftotext.exe:
# In command prompt: pdftotxt C:\pdfFolder\*.pdfs C:\txtFolder\*.txt

#Mark Larsen 2016
use strict;
#use warnings;

use CAM::PDF;
use CAM::PDF::PageText;

#in cmd: courts.pl samplePDF.pdf
my $filename = shift || die "Supply pdf on command line\n";

my $pdf = CAM::PDF->new($filename);

my $loop = 1;
my $pages = $pdf->numPages();

print "There are $pages pages in this pdf (press enter)";
<STDIN>;

while ($loop < $pages){
	#my $string = text_from_page($loop);
	pdf_parsing();
	$loop++;
}

sub pdf_parsing {
	my $string = text_from_page($loop);

	$string =~ s/([A-Za-z]+)( )([A-Za-z])/$1$3/g; #removes the space before the last letter in the word (Replaces a "$1,$2,$3" match with only "$1,$3")
	$string =~ s/  / /g; #replaces double spaces with single spaces

	print $string . "\n";


	while ($string =~ /(Deputy) (?<name1>\w+)/g){ #finds Deputy and prints the name afterwards
		print "The Deputy's name is $+{name1} \n"; 
	}


	open(my $fh, '>', 'reports.txt');
	print $fh "$string";
	close $fh;
	print "done\n";
}

sub text_from_page {
my $pg_num = shift;

return
CAM::PDF::PageText->render($pdf->getPageContentTree($pg_num));
}
