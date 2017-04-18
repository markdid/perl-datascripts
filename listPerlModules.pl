#!/usr/bin/perl -w
#Mark Larsen 2016
#prints list of all perl modules currently installed

use ExtUtils::Installed;
my $inst    = ExtUtils::Installed->new();
my @modules = $inst->modules();
 foreach $module (@modules){
      print $module . "\n";
}