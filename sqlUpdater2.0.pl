use strict;
use warnings;
#Mark Larsen 2/7/17

my $dataFile = "widgetLinks.txt";
#***update correct dates when running***
my $enteredDate = '2017-02-07';
my $changedDate = '2017-02-07 15:46:22.000'

open(my $data, '<', $dataFile) or die "couldn't open $dataFile $!\n";

while (my $line = <$data>) {
  chomp $line;
 
  my @fields = split "###" , $line;
 
  open my $outfile, '>>', "urls.sql";
	print $outfile "INSERT INTO tblURL (Url, Title, DateEntered, Active, DateLastChecked)\nVALUES (\'$fields[1]\', \'$fields[0]\', CONVERT(datetime, \'$enteredDate\', 120), 1, CONVERT(datetime, \'$changedDate\', 120));\n";
	#$found = 0;
	close $outfile;
}
#http://sfx.lib.byu.edu/sfxlcl3?ctx_ver=Z39.88-2004&ctx_enc=info:ofi/enc:UTF-8&ctx_tim=2012-01-12T16%3A09%3A03IST&url_ver=Z39.88-2004&url_ctx_fmt=infofi/fmt:kev:mtx:ctx&rfr_id=info:sid/primo.exlibrisgroup.com:primo3-Article-gale_litrc&rft_val_fmt=info:ofi/fmt:kev:mtx:&rft.genre=article&rft.atitle=Encyclopedia%20of%20the%20American%20Constitution.&rft.jtitle=Library%20Journal&rft.btitle=&rft.aulast=&rft.auinit=&rft.auinit1=&rft.auinitm=&rft.ausuffix=&rft.au=Tallent%2C%20Ed&rft.aucorp=&rft.date=19970315&rft.volume=122&rft.issue=5&rft.part=&rft.quarter=&rft.ssn=&rft.spage=97&rft.epage=&rft.pages=&rft.artnum=&rft.issn=0363-0277&rft.eissn=&rft.isbn=&rft.sici=&rft.coden=&rft_id=info:doi/&rft.object_id=&rft_dat=%3Cgale_litrc%3E19574842%3C/gale_litrc%3E&rft.eisbn=&rft_id=info:oai/
#line 311:
#https://search.lib.byu.edu/byu/record/lee.2842891?holding=hoeoc8hm79rrk15m