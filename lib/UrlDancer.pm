package UrlDancer;
use v5.10;
use Dancer ':syntax';
use Dancer::Plugin::DBIC qw( schema );
use Encode::Base58;

our $VERSION = '0.1';

eval { schema->deploy };

get '/' => sub {
    template 'index';
};

post '/' => sub {
    if( param('url') ) {
        # very dumb check to see whether this is some kind of URI
        return status 'bad_request'
            if param('url') !~ m/^[a-z]+:\/\/.+$/;

        my $url = schema->resultset('Url')->find_or_create({
            url => param('url')
        });
        my $return = {
            longurl  => param('url'),
            shorturl => request->uri_base."/".encode_base58( $url->id ),
        };

        given (param('render')) {
            when ('json') { content_type('text/json');
                            return to_json($return) }
            default       { return template 'index', $return }
        }
    }

    status 'bad_request';
};

get '/:id' => sub {
    my $id  = param('id');
    my $url = schema->resultset('Url')->search({
        id => decode_base58( $id )
    })->single if $id;

    $url->last_accessed(
        schema->storage->datetime_parser->format_datetime(
            DateTime->now(time_zone => config->{time_zone})
        )
    );
    $url->update;

    return redirect $url->url if $url;

    status 'not_found';
};

true;
