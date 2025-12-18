package Gears::X;

use v5.40;
use Mooish::Base -standard;

use overload
	q{""} => 'as_string',
	q{0+} => 'as_number',
	fallback => 1;

has param 'message' => (
	isa => Str,
	writer => -hidden,
);

has field 'caller' => (

	# isa => Maybe [ArrayRef],
	builder => 1,
);

sub base_class ($self)
{
	return __PACKAGE__;
}

sub no_trace_regex ($self)
{
	return qr/^(Gears|Type::Coercion)::/;
}

sub _build_caller ($self)
{
	my $no_trace = $self->no_trace_regex;
	for my $call_level (1 .. 20) {
		my ($package, $file, $line) = caller $call_level;
		next unless defined $package && $package !~ $no_trace;
		next unless defined $file && $file !~ /\(eval \d+\)/;

		return [$package, $file, $line];
	}

	return undef;
}

sub raise ($self, $error = undef)
{
	if (defined $error) {
		$self = $self->new(message => $error);
	}

	die $self;
}

sub trap_into ($class, $sub, $prefix = undef)
{
	try {
		return $sub->();
	}
	catch ($ex) {
		if (blessed $ex) {
			if ($ex->isa($class)) {
				$ex->_set_message("$prefix: " . $ex->message)
					if $prefix;
				$ex->raise;
			}
			if ($ex->isa(__PACKAGE__)) {
				$class->raise(($prefix ? "$prefix: " : '') . $ex->message);
			}
		}
		my $ex_string = "$ex";
		chomp $ex_string;    # remove \n from dying without trace
		$class->raise($prefix ? "$prefix: $ex_string" : $ex_string);
	}
}

sub as_string ($self, @)
{
	my $raised = $self->message;

	my $caller = $self->caller;
	if (defined $caller) {
		$raised .= ' (raised at ' . $caller->[1] . ', line ' . $caller->[2] . ')';
	}

	my $class = ref $self;
	my $base = $self->base_class;
	if ($class eq $base) {
		$class = '';
	}
	else {
		$class =~ s/^${base}::(.+)$/[$1] /;
	}

	return "An error occured: $class$raised";
}

sub as_number ($self, @)
{
	return refaddr $self;
}

