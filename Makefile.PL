

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'GPS::Point',
    VERSION_FROM => 'lib/GPS/Point.pm', # finds \$VERSION
    AUTHOR       => 'Michael R. Davis (account=>perl,tld=>com,domain=>michaelrdavis)',
    ABSTRACT     => 'Provides an object interface for a GPS point.',
    PREREQ_PM    => {
                     'Test::Simple' => 0.44,
                    },
);
