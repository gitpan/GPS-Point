package GPS::Point;
use strict;

BEGIN {
    use vars qw($VERSION);
    $VERSION     = '0.06';
}

=head1 NAME

GPS::Point - Provides an object interface for a GPS point.

=head1 SYNOPSIS

  use GPS::Point;
  my $obj=GPS::Point->newGPSD($GPSD_O_line);#e.g. GPSD,O=....
  my $obj=GPS::Point->new(
         time        => $time,    #float seconds from the unix epoch
         lat         => $lat,     #signed degrees
         lon         => $lon,     #signed degrees
         alt         => $hae,     #meters above the WGS-84 ellipsoid
         speed       => $speed,   #meters/second (over ground)
         heading     => $heading, #degrees clockwise from North
         climb       => $climb,   #meters/second
         etime       => $etime,   #float seconds
         ehorizontal => $ehz,     #float meters
         evertical   => $evert,   #float meters
         espeed      => $espeed,  #meters/second
         eheading    => $ehead,   #degrees
         eclimb      => $eclimb,  #meters/second
         mode        => $mode,    #GPS mode [?=>undef,None=>1,2D=>2,3D=>3]
         tag         => $tag,     #Name of the GPS message for data
       ); 

=head1 DESCRIPTION

This is a re-write of L<Net::GPSD::Point> that is more portable.

GPS::Point - Provides an object interface for a GPS fix (e.g. Position, Velocity and Time).

  Note: Please use Geo::Point, if you want 2D or projection support.

=head1 USAGE

  print $point->latlon. "\n";               #use a "." here to force latlon to scalar context
  my ($x,$y,$z)=$point->ecef;               #if Geo::ECEF is available
  my $GeoPointObject=$point->GeoPoint;      #if Geo::Point is available
  my @distance=$point->distance($point2);   #if Geo::Inverse is available
  my $distance=$point->distance($point2);   #if Geo::Inverse->VERSION >=0.05

=head1 USAGE TODO

  my $obj=GPS::Point->newNMEA($NMEA_lines); #e.g. GGA+GSA+RMC

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

=head2 newGPSD

  my $obj=GPS::Point->newGPSD($GPSD_O_line);#e.g. GPSD,O=....

=cut

sub newGPSD {
  my $this = shift();
  my $class = ref($this) || $this;
  my $self = {};
  bless $self, $class;
  $self->initializeGPSD(@_);
  return $self;
}

=head1 METHODS

=cut

sub initialize {
  my $self = shift();
  %$self=@_;
}

sub initializeGPSD {
  my $self=shift();
  my $line=shift(); #GPSD,O=MID2 1175911006.190 ? 53.527185 -113.530093 705.51 4.00 3.49 0.0000 0.074 0.101 ? 8.00 6.99 3
  my @line=split(/,/, $line);
  warn("Warning: Expected GPSD formatted line.") unless $line[0] eq "GPSD";
  my $obj=undef();
  foreach (@line) { #I pull the last one if O=?,O=?,...
    my @rpt=split(/=/, $_);
    if ($rpt[0] eq 'O') {
      my @data=map {q2u($_)} split(/\s+/, $rpt[1]);
      %$self=(tag         => $data[ 0],
              time        => $data[ 1],
              etime       => $data[ 2],
              lat         => $data[ 3],
              lon         => $data[ 4],
              alt         => $data[ 5],
              ehorizontal => $data[ 6],
              evertical   => $data[ 7],
              heading     => $data[ 8],
              speed       => $data[ 9],
              climb       => $data[10],
              eheading    => $data[11],
              espeed      => $data[12],
              eclimb      => $data[13],
              mode        => $data[14]);
    }
  } 
}

=head2 time

Sets or returns seconds since the Unix epoch, UTC (float, seconds)

  print $obj->time, "\n";

=cut

sub time {
  my $self = shift();
  $self->{'time'}=shift() if @_;
  return $self->{'time'};
}

=head2 lat, latitude

Sets or returns Latitude (float, degrees)

  print $obj->lat, "\n";

=cut

*latitude=\&lat;

sub lat {
  my $self = shift();
  $self->{'lat'}=shift() if @_;
  return $self->{'lat'};
}

=head2 lon, long or longitude

Sets or returns Longitude (float, degrees)

  print $obj->lon, "\n";

=cut

*longitude=\&lon;
*long=\&lon;

sub lon {
  my $self = shift();
  $self->{'lon'}=shift() if @_;
  return $self->{'lon'};
}

=head2 alt, altitude

Sets or returns Altitude (float, meters) 

  print $obj->alt, "\n";

=cut

*altitude=\&alt;

sub alt {
  my $self = shift();
  $self->{'alt'}=shift() if @_;
  return $self->{'alt'};
}

=head2 speed

Sets or returns speed (float, meters/sec)

  print $obj->speed, "\n";

=cut

sub speed {
  my $self = shift();
  $self->{'speed'}=shift() if @_;
  return $self->{'speed'};
}

=head2 heading, bearing

Sets or returns heading (float, degrees)

  print $obj->heading, "\n";

=cut

*bearing=\&heading;

sub heading {
  my $self = shift();
  $self->{'heading'}=shift() if @_;
  return $self->{'heading'};
}

=head2 climb

Sets or returns vertical velocity (float, meters/sec)

  print $obj->climb, "\n";

=cut

sub climb {
  my $self = shift();
  $self->{'climb'}=shift() if @_;
  return $self->{'climb'};
}

=head2 etime

Sets or returns estimated timestamp error (float, seconds, 95% confidence)

  print $obj->etime, "\n";

=cut

sub etime {
  my $self = shift();
  $self->{'etime'}=shift() if @_;
  return $self->{'etime'};
}

=head2 ehorizontal

Sets or returns horizontal error estimate (float, meters)

  print $obj->ehorizontal, "\n";

=cut

sub ehorizontal {
  my $self = shift();
  $self->{'ehorizontal'}=shift() if @_;
  return $self->{'ehorizontal'};
}

=head2 evertical

Sets or returns vertical error estimate (float, meters)

  print $obj->evertical, "\n";

=cut

sub evertical {
  my $self = shift();
  $self->{'evertical'}=shift() if @_;
  return $self->{'evertical'};
}

=head2 espeed

Sets or returns error estimate for speed (float, meters/sec, 95% confidence)

  print $obj->espeed, "\n";

=cut

sub espeed {
  my $self = shift();
  $self->{'espeed'}=shift() if @_;
  return $self->{'espeed'};
}

=head2 eheading

Sets or returns error estimate for course (float, degrees, 95% confidence)

  print $obj->eheading, "\n";

=cut

sub eheading {
  my $self = shift();
  $self->{'eheading'}=shift() if @_;
  return $self->{'eheading'};
}

=head2 eclimb

Sets or returns Estimated error for climb/sink (float, meters/sec, 95% confidence)

  print $obj->eclimb, "\n";

=cut

sub eclimb {
  my $self = shift();
  $self->{'eclimb'}=shift() if @_;
  return $self->{'eclimb'};
}

=head2 mode

Sets or returns the NMEA mode (integer; undef=>no mode value yet seen, 1=>no fix, 2=>2D, 3=>3D)

  print $obj->mode, "\n";

=cut

sub mode {
  my $self = shift();
  $self->{'mode'}=shift() if @_;
  return $self->{'mode'};
}

=head2 tag

Sets or returns a tag identifying the last sentence received. For NMEA devices this is just the NMEA sentence name; the talker-ID portion may be useful for distinguishing among results produced by different NMEA talkers in the same wire. (string)

  print $obj->tag, "\n";

=cut

sub tag {
  my $self = shift();
  $self->{'tag'}=shift() if @_;
  return $self->{'tag'};
}

=head2 fix

Returns either 1 or 0 based upon if the GPS point is from a valid fix or not.

  print $obj->fix, "\n";

=cut

sub fix {
  my $self = shift();
  return $self->mode > 1 ? 1 : 0;

}

=head2 latlon, latlong

Returns Latitude, Longitude as an array in array context and as a space joined string in scalar context

  my @latlon=$point->latlon;
  my $latlon=$point->latlon;

=cut

*latlong=\&latlon;

sub latlon {
  my $self = shift();
  my @latlon=($self->lat, $self->lon);
  return wantarray ? @latlon : join(" ", @latlon);
}

=head2 ecef

Returns ECEF coordinates if L<Geo::ECEF> is available.

  my ($x,$y,$z) = $point->ecef;
  my @xyz       = $point->ecef;
  my $xyz_aref  = $point->ecef; #if Geo::ECEF->VERSION >= 0.08

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

Returns a L<Geo::Point> Object in the WGS-84 projection.

  my $GeoPointObject = $point->GeoPoint;

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

Returns distance if L<Geo::Inverse> is installed. The argument can be a L<GPS::Point>, L<Geo::Point> or a Lat, Lon scalar pair.

  my ($faz, $baz, $dist) = $point->distance($pt2); #Array context
  my $dist = $point->distance($lat, $lon);  #if Geo::Inverse->VERSION >=0.05 

=cut

sub distance {
  my $self = shift();
  eval 'use Geo::Inverse';
  if ($@) {
    die("Error: The distance method requires Geo::Inverse");
  } else {
    my $obj = Geo::Inverse->new(); # default "WGS84"
    my $pt2=shift();
    my $lat1=$self->lat;
    my $lon1=$self->lon;
    my $lat2;
    my $lon2;
    if (ref($pt2) eq "GPS::Point" or ref($pt2) eq "Geo::Point") {
      $lat2=$pt2->latitude;
      $lon2=$pt2->longitude;
    } elsif (!ref($pt2)) {
      $lat2=$pt2;
      $lon2=shift();
    }
    if (length($lat2) && length($lon2)) {
      return $obj->inverse($lat1,$lon1,$lat2,$lon2);
    } else {
      die(qq{Error: Cannot calculate distance with "$lat2" and "$lon2".});
    }
  }
}

sub q2u {
  my $a=shift();
  return $a eq '?' ? undef() : $a;
}

=head1 BUGS

=head1 SUPPORT

Try GPSD-DEV email list

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

L<Geo::Point>, L<Net::GPSD::Point>, L<Geo::ECEF>, L<Geo::Functions>, L<Geo::Inverse>, L<Geo::Distance>

=cut

1;
