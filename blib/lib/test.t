#!/usr/bin/perl

use strict;
use warnings;
use NWS::Weather;
use Test::More tests => 5;
use Test::Deep;

my $zip = '77598';

my $weather = NWS::Weather->new;
my @results = $weather->local($zip);

is(
	$#results gt 1,
	1,
	"Local function with zip code returned weather"
);

my @ohio_zip = $weather->local('45424');

is(
	$#ohio_zip gt 1,
	1,
	"Local function with zip code returned weather"
);

my @houston = $weather->local('Houston, TX');

is(
	$#houston gt 1,
	1,
	"Local function with City, State returned weather"
);

my @ohio_st = $weather->local('Dayton, OH');

is(
	$#ohio_st gt 1,
	1,
	"Local function with City, State returned weather"
);

my @fail = $weather->local();

like(
	$fail[-1],
	qr/enter a location/,
	"Not entering a location provides correct error"
);
