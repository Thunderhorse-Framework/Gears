package Gears::Router::Pattern::Match;

use v5.40;
use Mooish::Base -standard;

extends 'Gears::Router::Pattern';

sub compare ($self, $request_path)
{
	my $pattern = $self->location->pattern;

	if ($self->location->is_bridge) {
		return $request_path =~ m/^\Q$pattern\E/;
	}
	else {
		return $request_path eq $pattern;
	}
}

sub build ($self, @more_args)
{
	return $self->location->pattern;
}

