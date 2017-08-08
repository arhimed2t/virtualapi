#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';
use VirtualAPI;

# Get config from json files
my @urls = ();
if (scalar @ARGV) {
    my $json;
    eval {
        require JSON;
        $json = JSON->new();
    };
    my @files;
    if ($json && !$@) {
        local $/ = undef;
        @files = grep {
            my $file = $_;
            my $fh;
            my @content;
            if (open $fh => "<$file") {
                eval { @content = $json->decode(<$fh>); };
            }
            scalar @content
        } @ARGV;

        @urls = map {
            my $file = $_;
            my $content;
            if (open my $fh => "<$file") {
                binmode $fh;
                eval { $content = $json->decode(<$fh>); };
            }
            $content
        } @files;
    }
}

#### Map some dynamically changed structure placed to @urls
push @urls, {
    map {
        my @chars = ("A".."Z", "a".."z");
        my $string;
        $string .= $chars[rand @chars] for 1 .. 8;
        (
            route => $string,
            header => [
                -type => 'text/html',
                -content => $string,
            ]
        )
    } (1) # Just counter
};
####

my $vapi = VirtualAPI->_new(
    port => 9090,
    background => 0,
    urls => [
        @urls, # Urls from ARGV
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

$vapi->_run();

__DATA__

# Usage:
curl -X POST http://localhost:9090/foobar
