package Gears::Router::Pattern;

use v5.40;
use Mooish::Base -standard;

has param 'location' => (
	isa => InstanceOf ['Gears::Router::Location'],
	weak_ref => 1,
	handles => [qw(is_bridge)],
);

sub compare ($self, $request_path)
{
	...;
}

sub build ($self, @more_args)
{
	...;
}

