#Mark Larsen 2/9/17
#time is not dynamic - use sqlUpdater2.0.pl instead
use strict;
use warnings;

my $dataFile = "status.txt";
#***update dates to current***
my $enteredDate = '2017-02-09';
my $changedDate = '2017-02-09 16:05:22.000';
open(my $data, '<', $dataFile) or die "couldn't open $dataFile $!\n";

while (my $line = <$data>) {
  chomp $line;
 
  my @fields = split "###" , $line;
 
  open my $outfile, '>>', "urls.sql";
	print $outfile "INSERT INTO tblURL (Active)\nVALUES ($fields[0]);\n";
	#$found = 0;
	close $outfile;
}
