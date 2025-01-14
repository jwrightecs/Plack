use strict;
use warnings;
use Test::More;
use Plack::Test;
use Plack::Request;
use HTTP::Request::Common;
use JSON::PP;

my $app = sub {
    my $req = Plack::Request->new(shift);
    is_deeply $req->body_parameters, { foo => 'bar' };
    is $req->content, '{"foo":"bar"}';
    $req->new_response(200)->finalize;
};

test_psgi $app, sub {
    my $cb = shift;
    my $res = $cb->(POST "/", 'Content-Type' => 'application/json', Content => JSON::PP->new->encode({ foo => "bar" }));
    ok $res->is_success;
};

done_testing;
