package Gears::Router::Location;

use v5.40;
use Mooish::Base -standard;

use Gears::Router::Pattern;

has param 'pattern' => (
	isa => Str,
);

has field 'pattern_obj' => (
	isa => InstanceOf ['Gears::Router::Pattern'],
	lazy => 1,
);

with qw(
	Gears::Router::Proto
);

sub location_impl ($self)
{
	return ref $self;
}

sub is_bridge ($self)
{
	return $self->locations->@* > 0;
}

sub build ($self, @more_args)
{
	return $self->pattern_obj->build(@more_args);
}

sub _build_pattern_obj ($self)
{
	...;
}

