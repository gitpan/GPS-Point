# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 17;
use blib;

BEGIN { use_ok( 'GPS::Point' ); }

my $line=q{GPSD,O=MID2 1175911006.190 ? 53.527185 -113.530093 705.51 4.00 3.49 0.0000 0.074 0.101 ? 8.00 6.99 3};

my $object = GPS::Point->newGPSD($line);
isa_ok ($object, 'GPS::Point');

my @test=split(/=/, $line);
@test=map {q2u($_)} split(/\s+/, $test[1]);
is($object->tag,         $test[ 0], "newGPSD tag");
is($object->time,        $test[ 1], "newGPSD time");
is($object->etime,       $test[ 2], "newGPSD etime");
is($object->lat,         $test[ 3], "newGPSD lat");
is($object->lon,         $test[ 4], "newGPSD lon");
is($object->alt,         $test[ 5], "newGPSD alt");
is($object->ehorizontal, $test[ 6], "newGPSD ehoriz");
is($object->evertical,   $test[ 7], "newGPSD evert");
is($object->heading,     $test[ 8], "newGPSD heading");
is($object->speed,       $test[ 9], "newGPSD speed");
is($object->climb,       $test[10], "newGPSD climb");
is($object->eheading,    $test[11], "newGPSD eheading");
is($object->espeed,      $test[12], "newGPSD espeed");
is($object->eclimb,      $test[13], "newGPSD eclimb");
is($object->mode,        $test[14], "newGPSD mode");

sub q2u {
  my $s=shift();
  return $s eq '?' ? undef() : $s;
}
