#!/usr/bin/perl - this is a linux command
use strict;
use warnings;
#Mark Larsen 3/16/17
#used on briefs in LaCie2TB - E:/CombinedBriefs(1-10-2017)/
#putting it here since it could be useful

#This program finds all occurances of terms from the term.in file in all other .txt files in a directory.
#Then it outputs the file with counts for all the terms.
#it is dynamic so all that needs to be changed is the censor.txt file and it will update 

my @files = <*.txt>;
my $term_file = <censor.txt>;

#terms file
my @terms;
open my $termsopen, '<', $term_file;
while (<$termsopen>) {
	chomp $_;
	push @terms, $_;
}
close $termsopen;
print (@terms);
my $termLength = 0;

foreach my $t (@terms){
	$termLength++;
}

open my $outfile, '>>', "countOut.txt";
	
#HEADER:
print $outfile "File|Total";
foreach my $h (@terms){
	print $outfile ("|$h");
}
print $outfile "\n";
close $outfile;
print ("\n$termLength\n");

#open my $outfile, '>', "$termsearch.out";
#close $outfile;
my $docket;

foreach my $file (@files) {
	open my $fh, '<', $file or die "cannot open $file: $!";
	#my $foundTerm = 0;
	print "opened $file\n";
	my $lines = <$fh>;
	my $found = 0;
	my @countArray;
	
	for (my $items = 0; $items < $termLength; $items++){
		$countArray[$items] = 0;
	}
	
	$docket = $file;
	$docket =~ /(\d+)_/g;
	$docket = $1;
	print ("$docket\n");
	
	while (<$fh>){
		chomp $lines;
		foreach my $termsearch (@terms) {
			#print "looking for $termsearch\n";
			my $count = 0;
			$count += () = $_ =~ /$termsearch/gi;
			#if (/$termsearch/gi){
			if ($count != 0){
				print "Count: $count ";
				$found = 1;
				for (my $items = 0; $items < $termLength; $items++){
					if ($termsearch eq $terms[$items]){
						$countArray[$items]+= $count;
					}
				}
				
				print "found $termsearch - @countArray in file - $file\n";
			} 
		}
	}
	

	if ($found == 1){
		open $outfile, '>>', "countOut.txt";
		#DATA:
		#total count:
		my $total = 0;
		foreach my $num (@countArray){
			$total+= $num;
		}
		print $outfile "$file|$docket|$total";
		#individual count:
		for (my $items = 0; $items < $termLength; $items++){
			#if ($countArray[$items] > 0){
				print $outfile "|$countArray[$items]";
			#}
		}
		print $outfile "\n";
		close $outfile;
	
	}
	close $fh;	
}

