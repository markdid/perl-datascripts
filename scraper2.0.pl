#!/usr/bin/perl
#Mark Larsen 9/16/16 based on scraper_template.pl
use 5.18.2;
use open qw(:locale);
use strict;
use warnings qw(all);
use Mojo::UserAgent;
use Mojo::URL;
use HTTP::Tiny;

# Open log file #
open my $log, '>', 'log.txt' or die $!;

# Base URL #
my $base = Mojo::URL->new('http://law.resource.org/pub/us/case/reporter/US/');
my @urls = $base;

# Parallel connections limit #
my $max_conn = 10;

# User agent max number of allowed redirects #
my $ua = Mojo::UserAgent->new(max_redirects => 5);
$ua->proxy->detect;

# Number of current connections #
my $active = 0;


## Main recurring loop ##
Mojo::IOLoop->recurring(
	0 => sub {
		for ($active + 1 .. $max_conn) {
		
			# Dequeue or halt if there are no active crawlers anymore
			return ($active or Mojo::IOLoop->stop)
				unless my $url = shift @urls;
			
			# Fetch non-blocking just by adding a callback and marking as active
			++$active;
			$ua->get($url => \&get_callback);
		}
	}
);

# Start event loop if necessary #
Mojo::IOLoop->start unless Mojo::IOLoop->is_running;


## Subroutines ##
sub get_callback {
    my (undef, $tx) = @_;

    # Deactivate
    --$active;

    # Parse only OK HTML responses
    return
        if not $tx->res->is_status_class(200)
        or $tx->res->headers->content_type !~ m{^text/html\b}ix;

    # Request URL
    my $url = $tx->req->url;

    #say $url;
    parse_html($url, $tx);

    return;
}

sub parse_html {
    my ($url, $tx) = @_;

    say $tx->res->dom->at('html title')->text;
	
	if ($url =~ m/.*\/(.*)\/(.*.html)$/){
		unless (-e -d "$1"){
			mkdir "$1";
		}
		my $filename = "$1/$2";
		open my $fh, '>', "$filename" or die $!;
		my $html = $tx->res->dom->to_string;
		print $fh $html;
		close $fh;
	} else {
		# Extract and enqueue URLs
		for my $e ($tx->res->dom('td.volume > a[href]')->each) {

			# Validate href attribute
			my $link = Mojo::URL->new($e->{href});
			next if 'Mojo::URL' ne ref $link;

			# "normalize" link
			$link = $link->to_abs($tx->req->url)->fragment(undef);
			next unless grep { $link->protocol eq $_ } qw(http https);

			# Don't go deeper than /a/b/c
			#next if @{$link->path->parts} > 3;

			# Access every link only once
			state $uniq = {};
			++$uniq->{$url->to_string};
			next if ++$uniq->{$link->to_string} > 1;

			# Don't visit other hosts
			next if $link->host ne $url->host;

			push @urls, $link;
			#say " -> $link";
		}
		for my $e ($tx->res->dom('td.case_cite > a[href]')->each) {

			# Validate href attribute
			my $link = Mojo::URL->new($e->{href});
			next if 'Mojo::URL' ne ref $link;

			# "normalize" link
			$link = $link->to_abs($tx->req->url)->fragment(undef);
			next unless grep { $link->protocol eq $_ } qw(http https);

			# Don't go deeper than /a/b/c
			#next if @{$link->path->parts} > 3;

			# Access every link only once
			state $uniq = {};
			++$uniq->{$url->to_string};
			next if ++$uniq->{$link->to_string} > 1;

			# Don't visit other hosts
			next if $link->host ne $url->host;
			
			my $path = $link->to_string;
			
			push @urls, $link;
			#$say " -> $link";
		}
	}
    say '';

    return;
}
