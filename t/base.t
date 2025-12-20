use Test2::V1 -ipP;
use Gears qw(load_package);

################################################################################
# This tests whether basic function of the Gears module work
################################################################################

subtest 'should load packages' => sub {
	is load_package('Gears::Logger'), 'Gears::Logger', 'package returned';
	ok lives { Gears::Logger->new }, 'package loaded';
};

done_testing;

