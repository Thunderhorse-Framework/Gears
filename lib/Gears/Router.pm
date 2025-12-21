package Gears::Router;

use v5.40;
use Mooish::Base -standard;

use Gears::Router::Match;

has param 'location_impl' => (
	isa => Str,
);

with qw(Gears::Router::Proto);

sub pattern ($self)
{
	return '';
}

sub _build_match ($self, $loc, $match_data)
{
	return Gears::Router::Match->new(
		location => $loc,
		matched => $match_data,
	);
}

sub match ($self, $request_path)
{
	my $root = {
		pos => 0,
		locations => $self->locations,
		matched => [],
	};

	my @context = ($root);
	while (@context > 0) {
		for (;; ++$context[-1]{pos}) {
			my $loc = $context[-1]{locations}[$context[-1]{pos}];
			last unless defined $loc;

			next unless my $match_data = $loc->pattern_obj->compare($request_path);
			my $match = $self->_build_match($loc, $match_data);

			my $children = $loc->locations;
			if ($children->@* > 0) {
				++$context[-1]{pos};
				push @context, {
					pos => 0,
					locations => $children,
					matched => [$match],
				};

				redo; # avoid incrementing pos again
			}
			else {
				push $context[-1]{matched}->@*, $match;
			}
		}

		my $last_context = pop @context;
		push $context[-1]{matched}->@*, $last_context->{matched}
			if @context > 0;
	}

	return $root->{matched};
}

sub clear ($self)
{
	$self->locations->@* = ();
	return $self;
}

