# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 27;
use Test::Number::Delta;

BEGIN { use_ok( 'GPS::Point' ); }

my $pt1 = GPS::Point->new(
                          lat=>38.898748,
                          lon=>-77.037684,
                         );
isa_ok ($pt1, 'GPS::Point');

is($pt1->lat, 38.898748, 'pt1->lat');
is($pt1->lon, -77.037684, 'pt1->lon');

SKIP: {
  eval { require Geo::WebService::Elevation::USGS };
  skip "Geo::WebService::Elevation::USGS not installed", 8 if $@;

  is($pt1->alt, undef, 'pt1->alt');
  isa_ok ($pt1->setAltitude, 'GPS::Point');
  delta_ok($pt1->alt, 16.6736107, 'pt1->alt');
  is($pt1->lat, 38.898748, 'pt1->lat');
  is($pt1->lon, -77.037684, 'pt1->lon');

  is($pt1->alt(0), 0, 'pt1->alt');
  isa_ok ($pt1->setAltitude, 'GPS::Point');
  is($pt1->alt, 0, 'pt1->alt');

  is($pt1->lat(44.443892), 44.443892, 'pt1->lat');
  is($pt1->lon(15.054531), 15.054531, 'pt1->lon');
  is($pt1->alt(undef), undef, 'pt1->alt');
  isa_ok ($pt1->setAltitude, 'GPS::Point');
  delta_ok($pt1->alt, 9.0000000, 'pt1->alt');
  
  is($pt1->lat(40.023899), 40.023899, 'pt1->lat');
  is($pt1->lon(-79.310094), -79.310094, 'pt1->lon');
  is($pt1->alt(undef), undef, 'pt1->alt');
  isa_ok ($pt1->setAltitude, 'GPS::Point');
  delta_ok($pt1->alt, 909.2382202, 'pt1->alt');

  is($pt1->lat(90), 90, 'pt1->lat');
  is($pt1->lon(-179), -179, 'pt1->lon');
  is($pt1->alt(undef), undef, 'pt1->alt');
  isa_ok ($pt1->setAltitude, 'GPS::Point');
  is($pt1->alt, undef, 'pt1->alt');
}
