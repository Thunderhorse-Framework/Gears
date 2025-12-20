package Gears::Router::Location;

use v5.40;
use Mooish::Base -standard;

use Gears::Router::Comparator::Prefix;

has param 'parent' => (
	isa => ConsumerOf ['Gears::Router::Proto'],
	weak_ref => 1,
);

has param 'path' => (
	isa => Str,
);

has param 'comparator' => (
	isa => InstanceOf ['Gears::Router::Comparator'],
	default => sub { Gears::Router::Comparator::Prefix->new },
);

with qw(
	Gears::Router::Proto
);

sub BUILD ($self, $)
{
	$self->comparator->set_location($self);
}

sub _build_router ($self)
{
	return $self->parent->router;
}

around match => sub ($orig, $self, $request_path) {
	if ($self->comparator->compare($request_path)) {
		my $result = $self->$orig($request_path);
		unshift $result->@*, $self;
		return $result;
	}

	return [];
};

