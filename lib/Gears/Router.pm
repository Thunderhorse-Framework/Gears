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

sub _match_level ($self, $locations, $path)
{
	my @matched;
	foreach my $loc ($locations->@*) {
		next unless my $match_data = $loc->pattern_obj->compare($path);
		my $match = $self->_build_match($loc, $match_data);

		my $children = $loc->locations;
		if ($children->@* > 0) {
			push @matched, [$match, $self->_match_level($children, $path)];
		}
		else {
			push @matched, $match;
		}
	}

	return @matched;
}

sub match ($self, $request_path)
{
	return [$self->_match_level($self->locations, $request_path)];
}

sub flatten ($self, $matches)
{
	my @flat_matches;
	foreach my $match ($matches->@*) {
		if (ref $match eq 'ARRAY') {
			push @flat_matches, $self->flatten($match);
		}
		else {
			push @flat_matches, $match;
		}
	}

	return @flat_matches;
}

sub clear ($self)
{
	$self->locations->@* = ();
	return $self;
}

