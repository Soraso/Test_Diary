# Programming/Test_Diary/basic_diary/t

use strict;
use warnings;

use Test::More;
use User;



subtest 'topic' => {
	uer_ok 'User';
	isa_ok Use->new, Use;
	#ok undef my $user1 = User->new(User => 'John');
}

=pod
my $user1 = User->new(User => 'John');

ok (1,	'new() returned something' );
ok ( defined $user1);
ok ( $user1->isa('User'));
=cut