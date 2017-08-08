## Simple API mocker based on HTTP::Server::Simple

### Create API route

``` perl
use lib 'lib';
use VirtualAPI;

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

./start test_foo_bar.json test.json test.nojson

curl http://localhost:9090/foobar

or

perl test_cli.pl
