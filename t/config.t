use Test2::V1 -ipP;
use Gears::Config;

################################################################################
# This tests whether the basic config works
################################################################################

subtest 'should add perl vars' => sub {
	my $c = Gears::Config->new;
	$c->add(var => {a => 1});
	is $c->config, {a => 1}, 'config ok';
};

subtest 'should add file contents' => sub {
	my $c = Gears::Config->new;
	$c->add(file => 't/config/good2.pl');
	is $c->config, {c => 42}, 'config ok';
};

subtest 'should add file contents with perl config vars' => sub {
	my $c = Gears::Config->new(
		readers => [
			Gears::Config::Reader::PerlScript->new(
				declared_vars => {
					test => 'test var',
				}
			)
		],
	);

	$c->add(file => 't/config/good1.pl');
	is $c->config, {a => 1, b => 'test var', c => {c => 42}}, 'config ok';
};

subtest 'should not load bad perl script configs' => sub {
	my $c = Gears::Config->new;
	my $ex = dies { $c->add(file => 't/config/bad.pl') };
	like $ex, qr{\[Config\] error in t/config/bad\.pl:}, 'string ok';
	like $ex, qr{line 4}, 'line ok';
};

subtest 'should merge hashes' => sub {
	my $c = Gears::Config->new;
	$c->add(var => {a => {b => 1}});
	$c->add(var => {a => {c => 2}});
	is $c->config, {a => {b => 1, c => 2}}, 'config ok';
};

subtest 'should replace arrays' => sub {
	my $c = Gears::Config->new;
	$c->add(var => {a => [1]});
	$c->add(var => {a => [2]});
	is $c->config, {a => [2]}, 'config ok';
};

subtest 'should add array elements' => sub {
	my $c = Gears::Config->new;
	$c->add(var => {a => [1]});
	$c->add(var => {'+a' => [2]});
	is $c->config, {a => [1, 2]}, 'config ok';
};

subtest 'should remove array elements' => sub {
	my $c = Gears::Config->new;
	$c->add(var => {a => [1, 2, 3]});
	$c->add(var => {'-a' => [2]});
	is $c->config, {a => [1, 3]}, 'config ok';
};

done_testing;

