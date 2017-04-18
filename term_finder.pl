#!/usr/bin/perl
use strict;
use warnings;
#Mark Larsen 2016
#This program finds all occurances of terms from the term.in file and outputs summaries 

my @files = <*.html>;
my $term_file = <url.txt>;

#terms file
my @terms;
open my $termsopen, '<', $term_file;
while (<$termsopen>) {
	chomp $_;
	push @terms, $_;
}
close $termsopen;
print (@terms);

#open my $outfile, '>', "$termsearch.out";
#close $outfile;

foreach my $file (@files) {
	open my $fh, '<', $file or die "cannot open $file: $!";
	my $found =0;
	print "opened $file\n";
	my $lines = <$fh>;
	while (<$fh>){
		chomp $lines;
		#print "$lines\n";

		
		foreach my $termsearch (@terms) {
		#print "looking for $termsearch\n";
		
				if (/$termsearch/ig){
					
					print "found $termsearch - $_\n";
					open my $outfile, '>>', "urls.txt";
					print $outfile "$_";
					#$found = 0;
					close $outfile;
				} 
			
		}
	
	}
	#<STDIN>;
	close $fh;	
}

