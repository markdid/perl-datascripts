# DataScripts
Various useful scripts written in Perl

### Common functions used in perl scripts:

* Writing to a file:

	 ''' perl
	open my $headfile, '>>', "gapInfo.txt";
	print $headfile "Line #| (ID) gapStart| (ID) gapEnd\n";
	close $headfile;
	'''


* Find duplicates:

 ''' perl
	foreach my $string (@baseID) {
		$index++;
		my $firstIndex = 0;
	    next unless $seen{$string}++;
		my $secondMatch = $ID[$index][0];
		my $secondLine  = $ID[$index][1];
		my $secondSheet = $ID[$index][2];

		my $firstLine = 0;
		my $firstSheet = "";

		#find 1st index:
		foreach my $findID (@baseID) {
			$firstIndex++;
			if ($findID == $secondMatch){ #found original
				#$SecondMatch = $ID[$index][0]
				$firstLine  = $ID[$firstIndex][1];
				$firstSheet = $ID[$firstIndex][2];
				last; #equivalent to break
			}
		}
		print "$string ($secondMatch) on line: $secondLine, is duplicated with another index ($firstIndex) == ($firstLine)\n";
	 '''
	
* regex:
 ' if ($row =~ /((\w+\.? ){10})/){'
	
	
## See files
		

