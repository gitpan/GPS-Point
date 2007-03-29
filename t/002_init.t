# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 3;

BEGIN { use_ok( 'GPS::Point' ); }

my $object = GPS::Point->new(lat=>39,
                             lon=>-77);
isa_ok ($object, 'GPS::Point');

my $latlon=$object->latlon;
is($latlon, "39 -77", "latlon method");
