package Gears::Router;

use v5.40;
use Mooish::Base -standard;

use Gears::Router::Location;

has param 'location_impl' => (
	isa => ClassName->where(q{ $_->isa('Gears::Router::Location') }),
	default => 'Gears::Router::Location',
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

