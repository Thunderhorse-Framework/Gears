package Gears::Config;

use v5.40;
use Mooish::Base -standard;

use Gears::Config::Reader::PerlScript;
use Gears::X::Config;
use Value::Diff;

has param 'readers' => (
	isa => ArrayRef [InstanceOf ['Gears::Config::Reader']],
	default => sub { [Gears::Config::Reader::PerlScript->new] },
);

has field 'config' => (
	isa => HashRef,
	default => sub { {} },
);

my sub _merge ($this_conf, $this_diff)
{
	foreach my $key (keys $this_diff->%*) {
		my $value = $this_diff->{$key};
		my $ref = ref $value;
		my $array_mode;

		if ($ref eq 'ARRAY' && $key =~ /^([+-])/) {
			$array_mode = $1;
			$key = substr $key, 1;
		}

		if (!exists $this_conf->{$key}) {
			$this_conf->{$key} = $value;
		}
		elsif (ref $this_conf->{$key} ne $ref) {
			Gears::X::Config->raise("configuration key type mismatch for $key");
		}
		elsif ($ref eq 'HASH') {
			__SUB__->($this_conf->{$key}, $value);
		}
		elsif ($ref eq 'ARRAY') {
			if (!defined $array_mode) {
				$this_conf->{$key} = $value;
			}
			elsif ($array_mode eq '-' && diff($this_conf->{$key}, $value, \my $rest)) {
				$this_conf->{$key}->@* = $rest->@*;
			}
			elsif ($array_mode eq '+') {
				push $this_conf->{$key}->@*, $value->@*;
			}

		}
		else {
			$this_conf->{$key} = $value;
		}
	}

}

sub merge ($self, $hash)
{
	my $conf = $self->config;
	if (diff($hash, $conf, \my $diff)) {
		_merge($conf, $diff);
	}
}

sub parse ($self, $source_type, $source)
{
	if ($source_type eq 'file') {
		my $config;
		foreach my $reader ($self->readers->@*) {
			next unless $reader->handles($source);
			$config = $reader->parse($self, $source);
			last;
		}

		Gears::X::Config->raise("no reader to handle file: $source")
			unless defined $config;

		return $config;
	}
	elsif ($source_type eq 'var') {
		return $source;
	}
	else {
		Gears::X::Config->raise("unknown type of config to add: $source_type");
	}
}

sub add ($self, $source_type, $source)
{
	$self->merge($self->parse($source_type, $source));
	return $self;
}

sub get ($self, $path, $default = undef)
{
	my $current = $self->config;

	foreach my $part (split /\./, $path) {
		Gears::X::Config->raise("invalid config path $path at part $part - not a hash")
			unless ref $current eq 'HASH';

		return $default unless exists $current->{$part};
		$current = $current->{$part};
	}

	return $current;
}

