use strict;
use warnings;
use WWW::Mechanize;
#Mark Larsen 2/9/17
#pulls link and title data from the $url file

#link scraper

my $url  = "file:///C:/Users/LNIS/Documents/Perl_Projects/widgets.php.html";
#my $url   = "http://linkexample.html"; or file:///C:/Documentswebpage.html
my $printFile = "widgetLinks.txt";

my $mech  = WWW::Mechanize->new();

$mech->get( $url );

my @links = $mech->links();

foreach my $link (@links) {

   print "Url: "        . $link->url() . "\n";
   print "Title: " . $link->text() . "\n";
   my $linkURL = $link->url();
   my $linkText = $link->text();
  
	open my $write, '>>', "$printFile" or die "cannot open $printFile.txt: $!";
	print $write "$linkText###$linkURL\n";
	close $write;
}

#http://sfx.lib.byu.edu/sfxlcl3?ctx_ver=Z39.88-2004&ctx_enc=info:ofi/enc:UTF-8&ctx_tim=2012-01-12T16%3A09%3A03IST&url_ver=Z39.88-2004&url_ctx_fmt=infofi/fmt:kev:mtx:ctx&rfr_id=info:sid/primo.exlibrisgroup.com:primo3-Article-gale_litrc&rft_val_fmt=info:ofi/fmt:kev:mtx:&rft.genre=article&rft.atitle=Encyclopedia%20of%20the%20American%20Constitution.&rft.jtitle=Library%20Journal&rft.btitle=&rft.aulast=&rft.auinit=&rft.auinit1=&rft.auinitm=&rft.ausuffix=&rft.au=Tallent%2C%20Ed&rft.aucorp=&rft.date=19970315&rft.volume=122&rft.issue=5&rft.part=&rft.quarter=&rft.ssn=&rft.spage=97&rft.epage=&rft.pages=&rft.artnum=&rft.issn=0363-0277&rft.eissn=&rft.isbn=&rft.sici=&rft.coden=&rft_id=info:doi/&rft.object_id=&rft_dat=%3Cgale_litrc%3E19574842%3C/gale_litrc%3E&rft.eisbn=&rft_id=info:oai/