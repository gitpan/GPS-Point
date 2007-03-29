# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 2;

BEGIN { use_ok( 'GPS::Point' ); }

my $object = GPS::Point->new ();
isa_ok ($object, 'GPS::Point');
