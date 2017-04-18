use strict;
use warnings;
use Mojo::DOM;
#Mark Larsen 2/3/17
#simple web parser - loops through html selectors and pulls the $cell data from the input .html file

my @selectors = ('div.p a'); #div/span etc (<div class...) .(class name) selector ie: div.num p) EX: a[href^=http] (css selectors)
my $printFile = "widgets.txt";
my $dir = "C:/Users/LNIS/Documents/Perl_Projects/";
print @selectors;

foreach my $selector (@selectors){
	print " Enter the file name (file.html): ";
	my $file = <STDIN>;
	chomp($file);
	my $eachFile = $dir . $file;
	print "$eachFile\n";
	
	open my $fh, '<', $eachFile or die "cannot open $eachFile: $!"; #opens for the while loop
	my $paragraphNum = 0;
	print "opened $eachFile\n";
	my $doc;
	while (<$fh>){
		if ($doc){
			$doc = $doc.$_;
		} else {
			$doc = $_;
		}
		#print $doc;
	}
	close $fh;
	my $dom = Mojo::DOM->new->parse("$doc");
	for my $element($dom->find("$selector")->each){
		my $cell = $element->all_text;
		
		open my $write, '>>', "$printFile" or die "cannot open $printFile.txt: $!";
		print $write "$cell | \n";
		close $write;
	}
}