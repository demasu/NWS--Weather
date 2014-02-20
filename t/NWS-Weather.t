# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl NWS-Weather.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More;
BEGIN { plan tests => 5 };
use NWS::Weather;
my $weather = new_ok( NWS::Weather );
like(
	my $result = join(' ', $weather->local('77598')),
	qr/\w+\w.*[-0-9]{1,3}[CF]\s[-0-9]{1,3}[CF].Humidity.*Barometer.*Dewpoint.*Visibility\s[0-9.]{1,5}\s\w+/,
	"Got back valid weather with a zip code"
);

my @test = $weather->local('Webster, TX');
foreach my $line (@test) {
	print "$line\n";
}

like(
	$result = join(' ', $weather->local('Webster, TX')),
	qr/\w+\w.*[-0-9]{1,3}[CF]\s[-0-9]{1,3}[CF].Humidity.*Barometer.*Dewpoint.*Visibility\s[0-9.]{1,5}\s\w+/,
	"Got back valid weather with City, State"
);

like(
	$result = join(' ', $weather->local('Fake, ST')),
	qr//,
	"Got back nothing from a fake City, State"
);

like(
	$result = join(' ', $weather->local('00000')),
	qr//,
	"Got back nothing from a fake zip code"
);

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

