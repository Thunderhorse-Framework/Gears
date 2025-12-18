package Gears::Router::Proto;

use v5.40;
use Mooish::Base -standard, -role;

requires qw(
	_build_router
	path
);

has field 'router' => (
	isa => InstanceOf ['Gears::Router'],
	weak_ref => 1,
	lazy => 1,
);

has field 'locations' => (
	isa => ArrayRef [InstanceOf ['Gears::Router::Location']],
	default => sub { [] },
);

sub add ($self, $path, %data)
{
	my $location = $self->router->location_impl->new(
		%data,
		parent => $self,
		path => $self->path . $path,
	);

	push $self->locations->@*, $location;
	return $location;
}

sub match ($self, $request_path)
{
	my @matched;
	foreach my $location ($self->locations->@*) {
		push @matched, $location->match($request_path)->@*;
	}

	return \@matched;
}

