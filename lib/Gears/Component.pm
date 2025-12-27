package Gears::Component;

use v5.40;
use Mooish::Base -standard;

has param 'app' => (
	isa => InstanceOf ['Gears::App'],
	weak_ref => 1,
);

sub BUILD ($self, $)
{
	my $class = ref $self;

	# make sure superclass build method won't be called (avoid building the
	# same elements twice)
	if (exists &{"${class}::build"}) {
		$self->build;
	}
}

sub build ($self)
{
}

