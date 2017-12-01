#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use LWP::UserAgent;

my $ua = LWP::UserAgent->new();
my $response = $ua->get('http://localhost:9090/foobar');

print Dumper $response;
