# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 24;
use Test::Number::Delta;
use blib;

BEGIN { use_ok( 'GPS::Point' ); }

my $pt1 = GPS::Point->new(lat=>39,
                          lon=>-77);
isa_ok ($pt1, 'GPS::Point');

my $latlon=$pt1->latlon;
is($latlon, "39 -77", "latlon method");

is($pt1->lat,  39, "lat");
is($pt1->lon, -77, "lon");

my $pt2 = GPS::Point->new(lat=>39.1,
                          lon=>-77.1);
isa_ok ($pt2, 'GPS::Point');

SKIP: {
  eval { require Geo::Inverse };
  skip "Geo::Inverse not installed", 8 if $@;

  my @dist=$pt1->distance($pt2);
  delta_ok($dist[0], 322.08605713267, "faz");
  delta_ok($dist[1], 142.02305726502, "baz");
  delta_ok($dist[2], 14077.7169524386, "distance");

  @dist=$pt1->distance($pt2->lat, $pt2->lon);
  delta_ok($dist[0], 322.08605713267, "faz");
  delta_ok($dist[1], 142.02305726502, "baz");
  delta_ok($dist[2], 14077.7169524386, "distance");
  SKIP: {
    skip "Geo::Inverse->VERSION < 0.05", 2 if Geo::Inverse->VERSION < 0.05;
    my $dist=$pt1->distance($pt2);
    delta_ok( $dist, "14077.7169524386", "distance scalar with GPS::Point");
    $dist=$pt1->distance($pt2->lat, $pt2->lon);
    delta_ok( $dist, "14077.7169524386", "distance scalar with Lat, Lon");
  }
}

SKIP: {
  eval { require Geo::Point };
  skip "Geo::Point not installed", 7 if $@;

  my $pt=$pt1->GeoPoint;
  is( ref($pt),  "Geo::Point", "GeoPoint");
  is( $pt->lat,   "39", "GeoPoint->lat");
  is( $pt->long, "-77", "GeoPoint->long");

  SKIP: {
    eval { require Geo::Inverse };
  
    skip "Geo::Inverse not installed", 4 if $@;
    my $pt3=$pt2->GeoPoint;
    my @dist=$pt1->distance($pt3);
    delta_ok($dist[0], 322.08605713267, "faz");
    delta_ok($dist[1], 142.02305726502, "baz");
    delta_ok($dist[2], 14077.7169524386, "distance array context");
    SKIP: {
      skip "Geo::Inverse->VERSION < 0.05", 1 if Geo::Inverse->VERSION < 0.05;
      my $dist=$pt1->distance($pt3);
      delta_ok( $dist, "14077.7169524386", "distance scalar with Geo::Point");
    }
  }
}

SKIP: {
  eval { require Geo::ECEF };

  skip "Geo::ECEF not installed", 3 if $@;

  my @xyz=$pt1->ecef;
  delta_ok($xyz[0], 3857229.79658403, "ecef x" );
  delta_ok($xyz[1], 3123523.10163777, "ecef y" );
  delta_ok($xyz[2], 3992317.02275173, "ecef z" );
}

