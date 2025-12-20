package Gears::Router;

use v5.40;
use Mooish::Base -standard;

use Gears::Router::Location;
use Gears::Router::Comparator;

has param 'location_impl' => (
	isa => Str,
	default => 'Gears::Router::Location',
);

has param 'comparator_impl' => (
	isa => Str,
	default => 'Gears::Router::Comparator::Prefix',
);

with qw(Gears::Router::Proto);

sub path ($self)
{
	return '';
}

sub _build_router ($self)
{
	# we are the router
	return $self;
}

