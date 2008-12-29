# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 13;
use Test::Number::Delta;

BEGIN { use_ok( 'GPS::Point' ); }

my $pt1 = GPS::Point->new(time=>500,
                          lat=>39,
                          lon=>-77,
                          speed=>10,
                          heading=>45);
isa_ok ($pt1, 'GPS::Point');

is($pt1->lat, 39, 'pt1->lat');
is($pt1->lon, -77, 'pt1->lat');
is($pt1->time, 500, 'pt1->time');
is($pt1->speed, 10, 'pt1->speed');
is($pt1->heading, 45, 'pt1->heading');

SKIP: {
  eval { require Geo::ECEF };
  skip "Geo::ECEF not installed", 5 if $@;

  my $pt2=$pt1->track(100);
  isa_ok ($pt2, 'GPS::Point');
  delta_ok($pt2->lat, 39.0063691539629, 'pt2->lat');
  delta_ok($pt2->lon, -76.9918365515252, 'pt2->lat');
  is($pt2->time, 600, 'pt2->time');
  is($pt2->speed, 10, 'pt2->speed');
  is($pt2->heading, 45, 'pt2->heading');
}
