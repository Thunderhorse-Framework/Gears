package Gears::Router::Pattern::Match;

use v5.40;
use Mooish::Base -standard;

extends 'Gears::Router::Pattern';

sub compare ($self, $request_path)
{
	my $pattern = $self->pattern;

	if ($self->is_bridge) {
		return undef
			unless scalar $request_path =~ m/^\Q$pattern\E/;
	}
	else {
		return undef
			unless $request_path eq $pattern;
	}

	# this pattern does not really match anything other than the pattern itself
	# - return empty (but defined) list of matches
	return [];
}

sub build ($self, @more_args)
{
	return $self->pattern;
}

