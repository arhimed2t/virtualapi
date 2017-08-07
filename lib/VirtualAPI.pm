package VirtualAPI;

use strict;
use warnings;
use Data::Dumper;

$Data::Dumper::Terse = 1;

use lib 'lib';
use MyWebServer;

sub new {
    my ($class, %params) = @_;

    my $self = {};
    $self->{$_} = $params{$_} for keys %params;

    bless $self => $class;

    return $self;
}

sub run {
    my $self = shift;

    my $port = $self->{'port'} || 8080;
    my $background = $self->{'background'};
    my $webserver = MyWebServer->new($port);

    # Handle routes and methods
    if (ref $self->{'urls'} eq 'ARRAY') {
        no strict 'refs';
        for my $url (@{$self->{'urls'}}) {
            if (ref $url ne 'HASH') {
                die "Wrong VirtualAPI method format!";
            }
            *{'MyWebServer::' . $url->{'route'}} = sub {
                my $cgi = shift;
                return if ! ref $cgi;

                my @header = ();
                if (ref $url->{'header'} eq 'ARRAY') {
                    @header = @{$url->{'header'}};
                }
                else {
                    push $url->{'header'}, @header;
                }

                print(
                    $cgi->header(@header),
                    $cgi->start_html($url->{'start_html'}),
                    $cgi->h1($url->{'h1'}),
                    $cgi->body($url->{'body'}),
                    $cgi->end_html($url->{'end_html'}),
                );
            };
        }
    }

    my @subs = map { "/$_" } grep { $_ !~ /handle_request/ } list_subs('MyWebServer');
    print "Available routes are:\n", Dumper \@subs;

    if ($background) {
        my $pid = $webserver->background($port);
        print "Use 'kill $pid' to stop server.\n";
    }
    else {
        $webserver->run($port);
    }
}

sub list_subs {
    my $module = shift;

    no strict 'refs';
    return grep { defined &{"$module\::$_"} } keys %{"$module\::"};
}

1;

