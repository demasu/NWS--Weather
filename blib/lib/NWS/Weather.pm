package NWS::Weather;

use 5.006001;
use strict;
use warnings;
use WWW::Mechanize;
use HTML::Strip;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Weather ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(local haz_wx
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(local haz_wx
	
);

our $VERSION = '0.01';

sub new {
	my $self = {};
	bless($self);

	return $self;
}

sub local {

	my $self = shift;
	my $location = shift;

	if (!length $location || $location !~ /([0-9]{5}|[A-Za-z]+,(\s+)?[A-Za-z]+)/) {
		return "Please enter a location";
	}

	my $mech = WWW::Mechanize->new();
	my $url = 'http://www.weather.gov/';

	$mech->get( $url );

	$mech->submit_form(
		form_name 	=> 'getForecast',
		fields		=> { inputstring => "$location" },
		button		=> 'btnSearch'
	);

	my $hs = HTML::Strip->new();
	my $code = $mech->content();
	my $page = $hs->parse($code);

	my @weather = split(/\n/, $page);
	my $lines = $#weather + 1;
	my @newweather;
	my $newcount = 0;
	
	for (my $count=0; $count < $lines; $count++) {
		$weather[$count] =~ s/^[ \t]*//;
	}

	for (my $count=0; $count < $lines; $count++) {
		if ($weather[$count] !~ /^$/) {
			$newweather[$newcount] = $weather[$count];
			$newcount++;
		}
	}

	my ($temperature, $humidity, $windspeed, $barometer, $dewpoint, $heatindex, $visibility, @temperature);

	for (my $count=0; $count <= $#newweather; $count++) {
		if ($newweather[$count] =~ /\w+\s\w+\s[-0-9]{1,3}.[CF]\s[-0-9]{1,3}.[CF]/) {
			$temperature = $&;
			$temperature =~ s/([0-9]{1,3}).([CF])/$1$2/g;
		}
		if ($newweather[$count] =~ /Humidity(?:\s\w+)?\s[0-9]{1,3}%/) {
			$humidity = $&;
		}
		if ($newweather[$count] =~ /Wind\sSpeed\s[A-Z]{1,3}\s[0-9]{1,3}\s(mph|kph)/) {
			$windspeed = $&;
		}
		if ($newweather[$count] =~ /Barometer\s[0-9]{1,3}.[0-9]{1,2}.\w+/) {
			$barometer = $&;
		}
		if ($newweather[$count] =~ /Dewpoint\s[-0-9]{1,3}.[CF]\s.[-0-9]{1,3}.[CF]./) {
			$dewpoint = $&;
			$dewpoint =~ s/([0-9]{1,3}).([CF])/$1$2/g;
		}
		if ($newweather[$count] =~ /Visibility\s[0-9]{1,2}.[0-9]{1,2}.\w+/) {
			$visibility = $&;
		}
		if ($newweather[$count] =~ /Heat\sIndex\s[-0-9]{1,3}.[CF]\s.[-0-9]{1,3}.[CF]./) {
			$heatindex = $&;
			$heatindex =~ s/([0-9]{1,3}).([CF])/$1$2/g;
		}	
	}

	my @values;

	push(@values, $temperature)	unless(!$temperature);
	push(@values, $humidity   )	unless(!$humidity	);
	push(@values, $windspeed  )	unless(!$windspeed	);
	push(@values, $barometer  )	unless(!$barometer	);
	push(@values, $dewpoint   )	unless(!$dewpoint	);
	push(@values, $heatindex  ) unless(!$heatindex	);
	push(@values, $visibility )	unless(!$visibility	);

	return @values;

}

# Preloaded methods go here.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Weather - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Weather;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Weather, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

root, E<lt>root@astudyinfutility.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by root

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
