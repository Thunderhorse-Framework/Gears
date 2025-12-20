package Gears::Router::Location;

use v5.40;
use Mooish::Base -standard;

use Gears qw(load_package);

has param 'parent' => (
	isa => ConsumerOf ['Gears::Router::Proto'],
	weak_ref => 1,
);

has param 'path' => (
	isa => Str,
);

has field '_comparator' => (
	isa => InstanceOf ['Gears::Router::Comparator'],
	lazy => 1,
);

with qw(
	Gears::Router::Proto
);

sub _build_comparator ($self)
{
	return load_package($self->router->comparator_impl)->new(
		location => $self,
	);
}

sub _build_router ($self)
{
	return $self->parent->router;
}

around match => sub ($orig, $self, $request_path) {
	if ($self->_comparator->compare($request_path)) {
		my $result = $self->$orig($request_path);
		unshift $result->@*, $self;
		return $result;
	}

	return [];
};

