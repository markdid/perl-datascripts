use strict;
use warnings;
use Mojo::DOM;
#Mark Larsen 10/21/16

my $dir = 1;  
#my @selectors = ('p');
#print @selectors;
#<STDIN>;
#foreach my $selector (@selectors){

my $wordcount = 0;

sub perl_style_count {
        my $filename = shift;
        open(FILE, "<$filename") or die "Could not open file: $!";

        my ($lines, $words, $chars) = (0,0,0);

        while (<FILE>) {
            $lines++;
            $chars += length($_);
            $words += scalar(split(/\s+/, $_));
        }

        print "\nFile $filename contains";
     
        print "\nNumber of Words = " . $words . "\n";
        
		$wordcount = $words;
}

foreach $dir (1..546){
	my($path) = "C:/Users/LNIS/Documents/Perl_Projects/Scraped2.0/$dir"; 

	print( "working in: $path\n" );

	# trailing / 
	$path .= '/' if($path !~ /\/$/); 

	# loop through the files 
	for my $eachFile (glob($path . '*.txt')) { 

		# if the file is a directory 
		if( -d $eachFile)
		{
			# pass the directory to the routine
			recurse($eachFile);
		}
		else {
				
				perl_style_count($eachFile);
				open my $write, '>>', "fileWordCount.txt" or die "cannot open out.txt: $!";
				print "opened HERE: $eachFile \n";
				print $write "$eachFile | $wordcount\n";
				close $write;
		}
	}
}
