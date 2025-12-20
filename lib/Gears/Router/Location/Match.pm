package Gears::Router::Location::Match;

use v5.40;
use Mooish::Base -standard;

use Gears::Router::Pattern::Match;

extends 'Gears::Router::Location';

sub _build_pattern_obj ($self)
{
	return Gears::Router::Pattern::Match->new(
		location => $self,
	);
}

