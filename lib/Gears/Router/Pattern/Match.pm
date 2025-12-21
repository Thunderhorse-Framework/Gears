package Gears::Router::Pattern::Match;

use v5.40;
use Mooish::Base -standard;

extends 'Gears::Router::Pattern';

sub compare ($self, $request_path)
{
	my $pattern = $self->location->pattern;

	if ($self->is_bridge) {
		return undef
			unless scalar $request_path =~ m/^\Q$pattern\E/;
	}
	else {
		return undef
			unless $request_path eq $pattern;
	}

	return [];
}

sub build ($self, @more_args)
{
	return $self->location->pattern;
}

