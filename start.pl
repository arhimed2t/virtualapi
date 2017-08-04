#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';
use VirtualAPI;

my $vapi = VirtualAPI->new(
    port => 9090,
    background => 0,
    methods => [
        {
            route => 'foobar',
            header => [
                -type => 'application/foobar',
                -content => '{"json":"content"}',
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

