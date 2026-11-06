package Gears::Role::HasContext;

use v5.40;
use Mooish::Base -standard, -role;

use Devel::StrictMode;

has param 'context' => (
	(STRICT ? (isa => InstanceOf ['Gears::Context']) : ()),
	weak_ref => 1,
);

