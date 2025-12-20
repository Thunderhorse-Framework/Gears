package Gears::Router::Comparator::Prefix;

use v5.40;
use Mooish::Base -standard;

extends 'Gears::Router::Comparator';

has field '_regex' => (
	isa => RegexpRef,
	lazy => 1,
);

# build simple regex that matches the string
sub _build_regex ($self)
{
	my $path = $self->location->path;

	# it is a bridge if it has children
	if ($self->location->locations->@*) {
		return qr/^\Q$path\E/;
	}
	else {
		return qr/^\Q$path\E$/;
	}
}

sub compare ($self, $request_path)
{
	return $request_path =~ $self->_regex;
}

