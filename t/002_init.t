# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 37;
use Test::Number::Delta;
use strict;

BEGIN { use_ok( 'GPS::Point' ); }
BEGIN { use_ok( 'Geo::Inverse' ); }

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

my @dist=$pt1->distance($pt2);
delta_ok($dist[0], 322.08605713267, "faz");
delta_ok($dist[1], 142.02305726502, "baz");
delta_ok($dist[2], 14077.7169524386, "distance");

@dist=$pt1->distance($pt2->lat, $pt2->lon);
delta_ok($dist[0], 322.08605713267, "faz");
delta_ok($dist[1], 142.02305726502, "baz");
delta_ok($dist[2], 14077.7169524386, "distance");

my $dist=$pt1->distance($pt2);
delta_ok( $dist, "14077.7169524386", "distance scalar with GPS::Point");
$dist=$pt1->distance($pt2->lat, $pt2->lon);
delta_ok( $dist, "14077.7169524386", "distance scalar with Lat, Lon");

SKIP: {
  eval { require Geo::Point };
  skip "Geo::Point not installed", 7 if $@;

  my $pt=$pt1->GeoPoint;
  is( ref($pt),  "Geo::Point", "GeoPoint");
  is( $pt->lat,   "39", "GeoPoint->lat");
  is( $pt->long, "-77", "GeoPoint->long");

  my $pt3=$pt2->GeoPoint;
  my @dist=$pt1->distance($pt3);
  delta_ok($dist[0], 322.08605713267, "faz");
  delta_ok($dist[1], 142.02305726502, "baz");
  delta_ok($dist[2], 14077.7169524386, "distance array context");
  my $dist=$pt1->distance($pt3);
  delta_ok( $dist, "14077.7169524386", "distance scalar with Geo::Point");
}

SKIP: {
  eval { require Geo::ECEF };
  skip "Geo::ECEF not installed", 3 if $@;

  my @xyz=$pt1->ecef;
  delta_ok($xyz[0], 3857229.79658403, "ecef x" );
  delta_ok($xyz[1], 3123523.10163777, "ecef y" );
  delta_ok($xyz[2], 3992317.02275173, "ecef z" );
}

my $lat=39.1; my $lon=-77.1;
my $pt=bless {lat=>$lat, lon=>$lon}, "My::Point::Foo";
isa_ok($pt, "My::Point::Foo");
$dist=$pt1->distance($pt);
delta_ok( $dist, "14077.7169524386", "distance scalar with blessed HASH point");
$pt=bless {latitude=>$lat, longitude=>$lon}, "My::Point";
isa_ok($pt, "My::Point");
$dist=$pt1->distance($pt);
delta_ok( $dist, "14077.7169524386", "distance scalar with blessed HASH point");
$pt=bless {lat=>$lat, long=>$lon}, "MyPoint";
isa_ok($pt, "MyPoint");
$dist=$pt1->distance($pt);
delta_ok( $dist, "14077.7169524386", "distance scalar with blessed HASH point");
$pt={lat=>$lat, long=>$lon};
isa_ok($pt, "HASH");
$dist=$pt1->distance($pt);
delta_ok( $dist, "14077.7169524386", "distance scalar with HASH point");
$pt=[$lat, $lon];
isa_ok($pt, "ARRAY");
$dist=$pt1->distance($pt);
delta_ok( $dist, "14077.7169524386", "distance scalar with ARRAY point");
$pt=bless [$lat, $lon], "MyPointArray";
isa_ok($pt, "MyPointArray");
$dist=$pt1->distance($pt);
delta_ok( $dist, "14077.7169524386", "distance scalar with blessed ARRAY point");
