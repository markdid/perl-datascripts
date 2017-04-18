#!/usr/bin/perl
use strict;
use warnings;
#Mark Larsen 2016
#This program takes all the terms and replaces them with values in hash with format "Key:Value"
#Runs through each term in each .txt file in directory. Terms are global and case insensitive

#my $dir = 1;
#my @files = <*.html>;
my $term_file = <terms.in>; #terms in this file

#terms file
my @terms;
my %hash_terms;
open my $termsopen, '<', $term_file;
while (<$termsopen>) {
	chomp $_;
	my ($find, $replace) = split /:/, $_; #hash split by ":"
		$hash_terms{$find} = $replace;
	push @terms, $_; 
}
close $termsopen;
my $term;
my @values = values %hash_terms;
my @keys = keys %hash_terms;

print ("terms you want to replace are @keys \n");
print ("you want to replace them with @values \n");
<STDIN>;

my @lines;
my $line;
my $found = 0;
my $dir = 1;
#uses hash keys to sort through files. 
foreach $dir (1..546){
    my($path) = "G:/Resource.org/Scraped/$dir"; 

    print( "working in: $path\n" );

    # append a trailing / if it's not there 
    $path .= '/' if($path !~ /\/$/); 

    # loop through the files contained in the directory 
    for my $eachFile (glob($path . '*.html')) { 

        # if the file is a directory 
        if( -d $eachFile)
        {
            # pass the directory to the routine ( recursion )
            recurse($eachFile);
        }
        else
        {
            foreach my $term  (keys %hash_terms){
		#foreach my $file (@files) {

			#This part gets the 1st line of file. It was deleting it for some reason. It is added to the array below.
			open my $first, '<', $eachFile or die "cannot open $eachFile: $!";
			my $first_line = <$first>;
			if ($first_line =~ /$term/ig){ 
				$found = 1;
				print ("found in file $eachFile, $term \n\n");
				$first_line =~ s/$term/$hash_terms{$term}/ig;
				}
			close $first;
			#-------------------------------------------------------------------------------------------------------
			
			open my $fh, '<', $eachFile or die "cannot open $eachFile: $!"; #opens for the while loop
			print "opened $eachFile\n";
			my $lines = <$fh>;
			
			while (<$fh>){
				if ($_ =~ /$term/ig){ 
					$found = 1;
					print ("found in file $eachFile, $term \n\n");
					
					$_ =~ s/$term/$hash_terms{$term}/ig; #ig = case insensitive, global. \b = word boundery
					
					$line = $_;
					push @lines, $line;
					
				}else{
					push @lines, $_;
				}
			}
			
			if ($found == 1){
				unshift @lines, $first_line; #puts the 1st line onto the array
				print "Writing to file... ";
				open(my $fWRITE, '>', $eachFile); #prints array to file
					foreach my $i (@lines){
						print $fWRITE "$i";
						}
					close $fWRITE;
					print "done\n";
					$found = 0;
					}
			@lines = ""; #empties array for next file
			close $fh;	
		#}
			}		
        } 
    } 
 }

