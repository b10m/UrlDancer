use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'UrlDancer',
    AUTHOR              => q{Menno Blom <menno@b10m.net>},
    VERSION_FROM        => 'lib/UrlDancer.pm',
    ABSTRACT            => 'Short URLs. UrlDancer.',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Dancer'                => 0,
        'Dancer::Plugin::DBIC'  => 0,
        'Dancer::Plugin::DBIC'  => 0,
        'DBIx::Class::Core'     => 0,
        'DBIx::Class::Schema'   => 0,
        'Encode::Base58'        => 0,
        'Test::More'            => 0,
        'YAML'                  => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'UrlDancer-*' },
);
