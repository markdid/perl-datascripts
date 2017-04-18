#Mark Larsen 2017
use strict;
use warnings;
my @ID; #multi key
my @baseID; #non - 3 dimensional array - only contains ID's

#file Headers
open my $headfile, '>>', "gapInfo.txt";
print $headfile "Line #| (ID) gapStart| (ID) gapEnd\n";
close $headfile;

open my $headfile1, '>>', "duplicateInfo.txt";print $headfile1 "Dup ID| 1st Line| 1st Sheet| 2nd Line| 2nd Sheet\n";close $headfile1;

#for Array:
my $uniqueID = 0; 
my $spreadsheet = "";
my $lineNum = 0;

my $filename = 'unionSourcelist.txt';
open(my $fh, '<:encoding(UTF-8)', $filename) or die "Could not open file '$filename' $!";
my $prevID = 0;
#my $gapSize = 0;

my $whileC = 0;
#this loop finds gaps and pushes txt data onto a ID[$row][3] array where ID[i][0] = ID
#																		 ID[i][1] = line number
#																		 ID[i][2] = the spreadsheet
while (my $row = <$fh>) {
	++$lineNum; #rows with skips are counted in excel
	chomp $row;
	#parse unique ID, and spreadsheet name (Z)
	# translated: if (line matches with: a digit (ID) that can have a decimal. then has other data followed by (mad..bla bla..xlsx))
	if ($row =~ m/(\d+(\.\d+)?).+[A-Za-z].+(mad.+xlsx)/i){ #if not a blank/invalid line
		
		#array index:
		$whileC++;
		$uniqueID = $1;
		$spreadsheet = $3;
		#print ("ID: " . $uniqueID  . " spreadsheet: $spreadsheet \n");
		
		$uniqueID += 0; #force int
		push(@baseID, $uniqueID); #
		$ID[$whileC][0] = $uniqueID;
			#push @{ $ID[1] }, $lineNum; # 
			$ID[$whileC][1] = $lineNum;
			#push @{ $ID[2] }, $spreadsheet; # 
			$ID[$whileC][2] = $spreadsheet;
		
		
		#check for gaps
		if ($uniqueID != ($prevID + 1)){
			if (($uniqueID < ($prevID + 1.0)) && ($uniqueID >= $prevID)){	
			
			#ignore incriments less than 1:	
				
				#print (" $lineNum: $prevID -> $uniqueID\n");
			}
			else{ 
				print ("There is a gap on line $lineNum: $prevID --> $uniqueID\n"); 

				#$gapSize = ($row - $prevID);
				#output file:
				open my $outfile, '>>', "gapInfo.txt";
				print $outfile "$lineNum|$prevID|$uniqueID\n";
				close $outfile;
			}
		}
		$prevID = $uniqueID;
	}
}
print ("Size of array:  " . scalar @ID . " (press enter)\n");

<STDIN>;
my %seen;$lineNum = 0;my $index = 0;

#this loop finds and outputs duplicates in an array/hash
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
	open my $outfile1, '>>', "duplicateInfo.txt";
	#for all in ID's - check for matches - print out first and second match (w/ line #'s and spreadsheet table values
	print $outfile1 "$string|$firstLine|$firstSheet|$secondLine|$secondSheet\n";
	close $outfile1;
}
