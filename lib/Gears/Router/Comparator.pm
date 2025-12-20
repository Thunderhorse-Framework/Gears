package Gears::Router::Comparator;

use v5.40;
use Mooish::Base -standard;

has param 'location' => (
	isa => InstanceOf ['Gears::Router::Location'],
	weak_ref => 1,
	writer => 1,
	required => 0,
);

sub compare ($self, $request_path)
{
	...;
}

