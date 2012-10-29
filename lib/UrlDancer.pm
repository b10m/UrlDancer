package UrlDancer;
use v5.10;
use Dancer ':syntax';
use Dancer::Plugin::DBIC qw( schema );
use Encode::Base58;
use URI;

our $VERSION = '0.1';

eval { schema->deploy };

get '/' => sub {
    template 'index';
};

post '/' => sub {
    my $return   = {};

    if( URI->new(param('url'))->scheme =~ m/^(?:http|ftp)s?$/ ) {
        my $url = schema->resultset('Url')->find_or_create({
            url => param('url')
        });
        $return = {
            longurl  => param('url'),
            shorturl => request->uri_base."/".encode_base58( $url->id ),
        };
    } else {
        status 'bad_request';
        $return->{error} = "that doesn't look like a valid URL";
    }

    given (param('render')) {
        when ('json') { content_type('text/json');
                        return to_json($return) }
        default       { return template 'index', $return }
    }
};

get '/:id' => sub {
    my $id  = param('id');

    if( my $url = schema->resultset('Url')->search({
        id => decode_base58( $id )
    })->single) {
        $url->last_accessed(
            schema->storage->datetime_parser->format_datetime(
                DateTime->now(time_zone => config->{time_zone})
            )
        );
        $url->update;

        return redirect $url->url;
    }

    status 'not_found';
    template 'index', { error => "can't find that page" };
};

true;
