#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';
use VirtualAPI;

#### Map some structure and use them in constructor
my @urls = map {
    my @chars = ("A".."Z", "a".."z");
    my $string;
    $string .= $chars[rand @chars] for 1 .. 8;
    {
        route => $string,
        header => [
            -type => 'text/html',
            -content => $string,
        ]
    }
} (1); # Just counter
#### Also it can be placed to json files and be given from @ARGV

my $vapi = VirtualAPI->new(
    port => 9090,
    background => 0,
    urls => [
        @urls, # Generated urls
        {
            route => 'foobar',
            header => [
                -type => 'text/html',
                -content => '{"some":"json"}',
                -FooBar => 'Yeah!',
            ],
            start_html => "FooBar!",
            h1 => "FooBar!",
            body => 'Foo my Bar!',
            end_html => 'End',
        },
    ],
);

$vapi->run();

__DATA__

# Usage:
curl -X POST http://localhost:9090/foobar
