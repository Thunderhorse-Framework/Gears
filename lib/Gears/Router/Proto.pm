package Gears::Router::Proto;

use v5.40;
use Mooish::Base -standard, -role;

use Gears qw(load_package);

requires qw(
	pattern
);

has field 'locations' => (
	isa => ArrayRef [InstanceOf ['Gears::Router::Location']],
	default => sub { [] },
);

sub add ($self, $pattern, %data)
{
	my $location = load_package($self->location_impl)->new(
		%data,
		pattern => $self->pattern . $pattern,
	);

	push $self->locations->@*, $location;
	return $location;
}

