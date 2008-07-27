use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'GPS::Point',
    VERSION_FROM => 'lib/GPS/Point.pm',
    AUTHOR       => 'Michael R. Davis (account=>perl,tld=>com,domain=>michaelrdavis)',
    ABSTRACT_FROM=> 'lib/GPS/Point.pm',
    LICENSE      => 'perl',
    PREREQ_PM    => {
                     'Test::Simple'        => 0.44,
                     'Test::More'          => 0.44,
                     'Test::Number::Delta' => 0,
                     'strict'              => 0,
                     'vars'                => 0,
                     'Scalar::Util'        => 1.02,
                    },
);
