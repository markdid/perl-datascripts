use strict;
use warnings;
use Mojo::DOM;
#Mark Larsen 12/1/16
#outputs selector data to file

my $dir = 1;  
my @selectors = ('a href="');
print @selectors;
<STDIN>;
foreach my $selector (@selectors){

	foreach $dir (1..546){
		my($path) = "C:/Users/LNIS/Documents/Perl_Projects/Scraped2.0/$dir"; 

		print( "working in: $path\n" );

		# trailing / 
		$path .= '/' if($path !~ /\/$/); 

		# loop through the files 
		for my $eachFile (glob($path . '*.html')) { 

			# if the file is a directory 
			if( -d $eachFile)
			{
				# pass the directory to the routine
				recurse($eachFile);
			}
			else {

			
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
					$cell =~ s/\n//gm;
					if ($cell =~ /^\s+$/gm){
						print "false\n";
					}
					else{
						$paragraphNum++;
						#print "$cell\n";
						my $notDir = $eachFile;
						
						$notDir =~ s/(C:\/Users\/LNIS\/Documents\/Perl_Projects\/Scraped2.0\/\d+\/)(.+\.html)/$2/;
						open my $write, '>>', "div.prelims p.txt" or die "cannot open out.txt: $!";
						#print "opened HERE: $eachFile";
						print $write "$notDir || $cell || $paragraphNum\n";
						close $write;
					}
					
				}
				#<STDIN>;
			}
		}
	}
	print "Looking for $selector selector...";
}
