package Gears::Router::Match;

use v5.40;
use Mooish::Base -standard;

has param 'location' => (

	# isa => InstanceOf ['Gears::Router::Location'],
);

has param 'matched' => (

	# isa => ArrayRef,
);

