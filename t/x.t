use Test2::V1 -ipP;
use Gears::X;

use lib 't/lib';
use Gears::X::TestX;

################################################################################
# This tests whether exceptions work as expected
################################################################################

subtest 'should raise an exception from object' => sub {
	my $ex = Gears::X->new(message => 'test');
	my $ex2 = dies { $ex->raise };

	ok $ex == $ex2, 'raised ok';
};

subtest 'should raise an exception from class' => sub {
	my $ex = dies { Gears::X->raise('from_class') };
	is $ex->message, 'from_class', 'raised ok';
};

subtest 'should stringify correctly (base class)' => sub {
	my $ex = Gears::X->new(message => 'abcd');
	like "$ex", qr{An error occured: abcd \(raised at .+x\.t, line \d+\)}, 'stringified ok';
};

subtest 'should stringify correctly (subclass)' => sub {
	my $ex = Gears::X::TestX->new(message => 'abcd');
	like "$ex", qr{An error occured: \[TestX\] abcd \(raised at .+x\.t, line \d+\)}, 'stringified ok';
};

subtest 'should trap correctly (string exception)' => sub {
	my $ex = dies {
		Gears::X->trap_into(sub { die "yup\n" });
	};

	isa_ok $ex, 'Gears::X';
	is $ex->message, 'yup', 'message ok';
};

subtest 'should trap correctly (string exception + prefix)' => sub {
	my $ex = dies {
		Gears::X->trap_into(sub { die "yup\n" }, 'nope');
	};

	isa_ok $ex, 'Gears::X';
	is $ex->message, 'nope: yup', 'message ok';
};

subtest 'should trap correctly (another exception)' => sub {
	my $ex = dies {
		Gears::X->trap_into(sub { Gears::X::TestX->raise('yup') });
	};

	isa_ok $ex, 'Gears::X';
	is $ex->message, 'yup', 'message ok';
};

done_testing;

