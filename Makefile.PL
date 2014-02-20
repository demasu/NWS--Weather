use 5.006001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'NWS::Weather',
    VERSION_FROM      => 'lib/NWS/Weather.pm', # finds $VERSION
    PREREQ_PM         => {
		WWW::Mechanize => 1.72,
		HTML::Strip => 1.06
		}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/NWS/Weather.pm', # retrieve abstract from module
       AUTHOR         => 'root <root@astudyinfutility.com>') : ()),
);
