package Gears::Router::Match;

use v5.40;
use Mooish::Base -standard;

use Devel::StrictMode;

has param 'location' => (
	(STRICT ? (isa => InstanceOf ['Gears::Router::Location']) : ()),
);

has param 'matched' => (
	(STRICT ? (isa => ArrayRef) : ()),
);

