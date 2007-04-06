package GPS::Point;
use strict;

BEGIN {
    use vars qw($VERSION);
    $VERSION     = '0.03';
}

=head1 NAME

GPS::Point - Provides an object interface for a GPS point.

=head1 SYNOPSIS

  use GPS::Point;
  $obj=GPS::Point->new(
         time=>$time,       #float seconds from the unix epoch
         lat=>$lat,         #signed degrees
         lon=>$lon,         #signed degrees
         alt=>$hae,         #meters above the WGS-84 ellipsoid
         speed=>$speed,     #meters/second (over ground)
         heading=>$heading, #degrees clockwise from North
         climb=>$climb,     #meters/second
         etime=>$etime,     #float seconds
         ehorizontal=>$ehz, #float meters
         evertical=$evert,  #float meters
         espeed=>$espeed,   #meters/second
         eheading=>$ehead,  #degrees
         eclimb=>$eclimb,   #meters/second
         mode=>$mode,       #GPS mode [Unknown=>undef(),None=>1,2D=>2,3D=>3]
         tag=>$tag,         #Name of the GPS message for data
       ); 
  print $point->latlon. "\n";      #use a "." here to force latlon to a scalar
  my ($x,$y,$z)=$point->ecef;               #if Geo::ECEF is available
  my $GeoPoint=$point->GeoPoint;            #if Geo::Point is available
  my $distance=$point->distance($point2);   #if Geo::Inverse is available

=head1 SYNOPSIS TODO

  my $obj=GPS::Point->newGPSD($GPSD_O_line);#e.g. GPSD,O=....
  my $obj=GPS::Point->newNMEA($NMEA_lines); #e.g. GGA+GSA+RMC

=head1 DESCRIPTION

This is a re-write of Net::GPSD::Point that is more portable.

GPS::Point - Provides an object interface for a GPS fix (e.g. Position, Velocity and Time).  (Note: Please use Geo::Point, if you want 2D or projection support.)

=head1 USAGE

=head1 CONSTRUCTOR

=head2 new

  my $obj = GPS::Point->new();

=cut

sub new {
  my $this = shift();
  my $class = ref($this) || $this;
  my $self = {};
  bless $self, $class;
  $self->initialize(@_);
  return $self;
}

=head1 METHODS

=cut

sub initialize {
  my $self = shift();
  %$self=@_;
}

=head2 time

Sets or returns time

  print $obj->time, "\n";

=cut

sub time {
  my $self = shift();
  $self->{'time'}=shift() if @_;
  return $self->{'time'};
}

=head2 lat

Sets or returns lat

  print $obj->lat, "\n";

=cut

sub lat {
  my $self = shift();
  $self->{'lat'}=shift() if @_;
  return $self->{'lat'};
}

=head2 lon

Sets or returns lon

  print $obj->lon, "\n";

=cut

sub lon {
  my $self = shift();
  $self->{'lon'}=shift() if @_;
  return $self->{'lon'};
}

=head2 alt

Sets or returns alt

  print $obj->alt, "\n";

=cut

sub alt {
  my $self = shift();
  $self->{'alt'}=shift() if @_;
  return $self->{'alt'};
}

=head2 speed

Sets or returns speed

  print $obj->speed, "\n";

=cut

sub speed {
  my $self = shift();
  $self->{'speed'}=shift() if @_;
  return $self->{'speed'};
}

=head2 heading

Sets or returns heading

  print $obj->heading, "\n";

=cut

sub heading {
  my $self = shift();
  $self->{'heading'}=shift() if @_;
  return $self->{'heading'};
}

=head2 climb

Sets or returns climb

  print $obj->climb, "\n";

=cut

sub climb {
  my $self = shift();
  $self->{'climb'}=shift() if @_;
  return $self->{'climb'};
}

=head2 etime

Sets or returns etime

  print $obj->etime, "\n";

=cut

sub etime {
  my $self = shift();
  $self->{'etime'}=shift() if @_;
  return $self->{'etime'};
}

=head2 ehorizontal

Sets or returns ehorizontal

  print $obj->ehorizontal, "\n";

=cut

sub ehorizontal {
  my $self = shift();
  $self->{'ehorizontal'}=shift() if @_;
  return $self->{'ehorizontal'};
}

=head2 evertical

Sets or returns evertical

  print $obj->evertical, "\n";

=cut

sub evertical {
  my $self = shift();
  $self->{'evertical'}=shift() if @_;
  return $self->{'evertical'};
}

=head2 espeed

Sets or returns espeed

  print $obj->espeed, "\n";

=cut

sub espeed {
  my $self = shift();
  $self->{'espeed'}=shift() if @_;
  return $self->{'espeed'};
}

=head2 eheading

Sets or returns eheading

  print $obj->eheading, "\n";

=cut

sub eheading {
  my $self = shift();
  $self->{'eheading'}=shift() if @_;
  return $self->{'eheading'};
}

=head2 eclimb

Sets or returns eclimb

  print $obj->eclimb, "\n";

=cut

sub eclimb {
  my $self = shift();
  $self->{'eclimb'}=shift() if @_;
  return $self->{'eclimb'};
}

=head2 mode

Sets or returns GPS fix mode

  print $obj->mode, "\n";

=cut

sub mode {
  my $self = shift();
  $self->{'mode'}=shift() if @_;
  return $self->{'mode'};
}

=head2 tag

Sets or returns tag

  print $obj->tag, "\n";

=cut

sub tag {
  my $self = shift();
  $self->{'tag'}=shift() if @_;
  return $self->{'tag'};
}

=head2 latlon

Returns Latitude, Longitude as an array in array context and as a space joined string in scalar context

  my @latlon=$point->latlon;
  my $latlon=$point->latlon;

=cut

sub latlon {
  my $self = shift();
  my @latlon=($self->lat, $self->lon);
  return wantarray ? @latlon : join(" ", @latlon);
}

=head2 ecef

Returns ECEF coordinates

  my ($x,$y,$z) = $point->ecef;
  my @xyz       = $point->ecef;
  my $xyz       = $point->ecef; #[] if Geo::ECEF::VERSION >= 0.08

=cut

sub ecef {
  my $self = shift();
  eval 'use Geo::ECEF';
  if ($@) {
    die("Error: The ecef method requires Geo::ECEF");
  } else {
    my $obj=Geo::ECEF->new();
    return $obj->ecef($self->lat, $self->lat, $self->alt);
  }
}

=head2 GeoPoint

Returns GeoPoint Object

  my $gp = $point->GeoPoint;

=cut

sub GeoPoint {
  my $self = shift();
  eval 'use Geo::Point';
  if ($@) {
    die("Error: The GeoPoint method requires Geo::Point");
  } else {
    return Geo::Point->new(lat=>$self->lat, long=>$self->lon, proj=>'wgs84');
  }
}

=head2 distance

Returns distance

  my $gp = $point->distance($pt2);
  my $gp = $point->distance($lat, $lon);

=cut

sub distance {
  my $self = shift();
  eval 'use Geo::Inverse';
  if ($@) {
    die("Error: The distance method requires Geo::Inverse");
  } else {
    my $obj = Geo::Inverse->new(); # default "WGS84"
    my $pt2=shift();
    my ($lat1,$lon1,$lat2,$lon2)=($self->lat, $self->lon, $pt2->lat, $pt2->lon);
    my ($faz, $baz, $dist)=$obj->inverse($lat1,$lon1,$lat2,$lon2);
    return wantarray ? ($faz, $baz, $dist) : $dist;
  }
}

=head1 BUGS

=head1 SUPPORT

=head1 AUTHOR

    Michael R. Davis
    CPAN ID: MRDVT
    DavisNetworks.com
    account=>perl,tld=>com,domain=>michaelrdavis
    http://www.davisnetworks.com/

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


=head1 SEE ALSO

L<Geo::Point>, L<Net::GPSD::Point>, L<Geo::Distance>, L<Geo::ECEF>, L<Geo::Functions>

=cut

1;
