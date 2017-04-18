#Mark Larsen 10/6/16
#loops through dir (specified below) - grabs all path filenames
use strict;
use warnings;
use Mojo::DOM;

my $dir = 1;  
#my @selectors = ('p');
#print @selectors;
#<STDIN>;
#foreach my $selector (@selectors){

foreach $dir (100..145){
	my($path) = "F:/CourtBriefsWorkspace/boxes100-145/box" . $dir; 

	print( "working in: $path\n" );

	# trailing / 
	$path .= '/' if($path !~ /\/$/); 

	# loop through the files 
	for my $eachFile (glob($path . '*.pdf')) { 

		# if the file is a directory 
		if( -d $eachFile)
		{
			# pass the directory to the routine
			recurse($eachFile);
		}
		else {

				
				open my $write, '>>', "F_CourtBriefWorkspace.txt" or die "cannot open out.txt: $!";
				print "opened HERE: $eachFile \n";
				print $write "$eachFile | $eachFile\n";
				close $write;
		}
	}
}
