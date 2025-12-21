package Gears::Router;

use v5.40;
use Mooish::Base -standard;

use Gears::Router::Match;

has param 'location_impl' => (
	isa => Str,
);

with qw(Gears::Router::Proto);

sub pattern ($self)
{
	return '';
}

sub _build_match ($self, $loc, $match_data)
{
	return Gears::Router::Match->new(
		location => $loc,
		matched => $match_data,
	);
}

sub match ($self, $request_path)
{
	my @locations = $self->locations->@*;
	my @matched;

	while (@locations > 0) {
		my $loc = shift @locations;
		my $match_data = $loc->pattern_obj->compare($request_path);
		next unless $match_data;

		push @matched, $self->_build_match($loc, $match_data);
		unshift @locations, $loc->locations->@*;
	}

	return @matched;
}

sub clear ($self)
{
	$self->locations->@* = ();
}

