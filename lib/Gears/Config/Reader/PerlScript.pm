package Gears::Config::Reader::PerlScript;

use v5.40;
use Mooish::Base -standard;

use Gears::X::Config;
use Path::Tiny qw(path);

extends 'Gears::Config::Reader';

has param 'declared_vars' => (
	isa => HashRef,
	default => sub { {} },
);

sub handled_extensions ($self)
{
	return qw(pl);
}

# declare no lexical vars other than $vars (visible in eval)
sub _clean_eval
{
	my $_result;
	my $vars = $_[2];

	# avoid raising $@ when $@ is local
	my $_err = do {
		local $@;
		$_result = eval $_[1];
		$@;
	};

	die $_err if $_err;
	return $_result;
}

sub parse ($self, $config, $filename)
{
	my %vars = $self->declared_vars->%*;
	$vars{include} = sub ($inc_filename) {
		my $dir = path($filename)->parent;
		$config->parse(file => $dir->child($inc_filename));
	};

	my $vars_string = join '',
		map {
			if (ref $vars{$_} eq 'CODE') {
				qq{sub $_ { \$vars->{$_}->(\@_) }};
			}
			else {
				qq{sub $_ { \$vars->{$_} }};
			}
		}
		keys %vars;

	state $id = 0;
	++$id;
	my $eval = join ' ', split /\v/, <<~PERL;
	package Gears::Config::Reader::PerlScript::Sandbox$id;
	use strict;
	use warnings;
	use builtin qw(true false);
	$vars_string
	PERL

	try {
		return $self->_clean_eval(
			$eval . $self->_get_contents($filename),
			\%vars,
		);
	}
	catch ($ex) {
		Gears::X::Config->raise("error in $filename: $ex");
	}
}

