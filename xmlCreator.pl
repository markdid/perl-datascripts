use strict;
use warnings;
use Mojo::DOM;
use open ':std', ':encoding(utf-8)';
#Mark Larsen 11/7/2016
#finds selector data and outputs xml file with data from $bodyDir, $footnotesDir, $prelimsDir
my $dir = 1;  

my $bodyDir = "C:/Users/LNIS/Documents/Perl_Projects/Scraped2.0/body/";
my $footnotesDir = "C:/Users/LNIS/Documents/Perl_Projects/Scraped2.0/footNotes2.0/";
my $prelimsDir = "C:/Users/LNIS/Documents/Perl_Projects/Scraped2.0/prelims/";



my @selectors = ('div.num p');
print @selectors;
<STDIN>;
foreach my $selector (@selectors){

	foreach $dir (1..546){  
		my($path) = "C:/Users/LNIS/Documents/Perl_Projects/Scraped2.0/$dir"; 
		my $parties;
		my $cases;
			my $case;
		my $dates;
			my $date;
		my $prelims;
		my $body;
		my $footnote;
		
		#print "fileName = $notDir\n";
		print "working in: $path\n";

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
				#my $dom = Mojo::DOM->new->parse("$doc");
				#for my $element($dom->find("$selector")->each){
				#	my $cell = $element->all_text;
				#	print "false\n";
				#	$paragraphNum++;
				#	#print "$cell\n";
				#
				my $notDir = $eachFile;
				$notDir =~ s/(C:\/Users\/LNIS\/Documents\/Perl_Projects\/Scraped2.0\/\d+\/)(.+\.html)/$2/;
				
				# PRELIMS ------------------------------------------
				my $prelimsFile = "$prelimsDir" . "$notDir" . "-prelims.txt";
				if (-e $prelimsFile){
					open my $fhp, '<', $prelimsFile or die "cannot open $prelimsFile: $!";
						while (<$fhp>){
						if ($prelims){
							$prelims = $prelims.$_;
						} else {
							$prelims = $_;
						}
					}
					close $fhp;
				}
				else{
					$prelims = "";
				}
				
				
				# BODY ---------------------------------------------
				my $bodyFile = "$bodyDir" . "$notDir" . "-body.txt";
				if (-e $bodyFile){
					open my $fhb, '<', $bodyFile or die "cannot open $bodyFile: $!";
						while (<$fhb>){
						if ($body){
							$body = $body.$_;
						} else {
							$body = $_;
						}
					}
					close $fhb;
				}
				else{
					$body = "";
				}
				
				# FOOTNOTES ---------------------------------------------
				my $footnoteFile = "$footnotesDir" . "$notDir" . "-footnotes.txt";
				if (-e $footnoteFile){
					open my $fhf, '<', $footnoteFile or die "cannot open $footnoteFile: $!";
						while (<$fhf>){
						if ($footnote){
							$footnote = $footnote.$_;
						} else {
							$footnote = $_;
						}
					}
					close $fhf;
				}
				else{
					$footnote = "";
				}
				
				print "The xml file: $eachFile\n";
				print "the body: $bodyFile\n";
				
				
				open my $write, '>>', "XML2/" . "$notDir" . ".xml" or die "cannot open out.txt: $!";
				#print "opened HERE: $eachFile";
				if ($prelims eq ""){
					print $write "<prelims>\n</prelims>\n";
				}else{
					print $write "<prelims>\n<text>$prelims</text>\n</prelims>\n";
				}
				
				if ($body eq ""){
					print $write "<body>\n</body>\n";
				}else{
					print $write "<body>\n<text>$body</text>\n</body>\n";
				}
				
				if ($footnote eq ""){
					print $write "<footnotes>\n</footnotes>";
				}else{
					print $write "<footnotes>\n<text>$footnote</text>\n</footnotes>";
				}
				
				close $write;
					
				}
				$body = "";
				$prelims = "";
				$footnote = "";
			}
		}
	}

	#print "Looking for $selector selector...";

