# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

sub near {
  my $x=shift();
  my $y=shift();
  
  return ($x-$y)/$y -1  <= 0.001;
}
use Test::More tests => 16;
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

  skip "Geo::Inverse not installed", 4 if $@;

  my $dist=$pt1->distance($pt2);
  is( $dist, "14077.7169524386", "distance" );
  my @dist=$pt1->distance($pt2);
  is( near($dist[0], "322.08605713267"), 1, "faz" );
  is( near($dist[1], "142.02305726502"), 1, "baz" );
  is( near($dist[2], "14077.7169524386"), 1, "distance" );
}

SKIP: {
  eval { require Geo::Point };

  skip "Geo::Point not installed", 3 if $@;

  my $pt=$pt1->GeoPoint;
  is( ref($pt),  "Geo::Point", "GeoPoint" );
  is( $pt->lat,   "39", "GeoPoint->lat" );
  is( $pt->long, "-77", "GeoPoint->long" );
}

SKIP: {
  eval { require Geo::ECEF };

  skip "Geo::ECEF not installed", 3 if $@;

  my @xyz=$pt1->ecef;
  is( near($xyz[0], "3857229.79658403"), 1, "ecef x" );
  is( near($xyz[1], "3123523.10163777"), 1, "ecef y" );
  is( near($xyz[2], "3992317.02275173"), 1, "ecef z" );
}
