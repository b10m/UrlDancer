# NAME

UrlDancer - Short URLs with Dancer

# VERSION

version 0.01

# SYNOPSIS

A simple short URL service using [Dancer](http://search.cpan.org/perldoc?Dancer).

To get started, first update the dsn setting in config.yml to point to a
database that your user has write access to.
Don't worry about creating the database tables.
UrlDancer will do that for you the first time it runs.

Then run the app with:

    $ ./bin/app.pl

In a production environment you probably want to run it with something like
[Starman](http://search.cpan.org/perldoc?Starman):

    $ starman -D ./bin/app.pl

# AUTHOR

Menno Blom <menno@b10m.net>
