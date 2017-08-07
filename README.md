## Simple API mocker based on HTTP::Server::Simple

### Create API route

``` perl
use lib 'lib';
use VirtualAPI;

my $vapi = VirtualAPI->new(
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

$vapi->run();
```

### Usage

./start

curl http://localhost:9090/foobar
or
perl test_cli.pl test.json test.nojson