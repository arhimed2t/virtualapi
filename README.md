## Simple API mocker based on HTTP::Server::Simple

### Create API route

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

### Usage

./start

curl http://localhost:9090/foobar

perl test_cli.pl