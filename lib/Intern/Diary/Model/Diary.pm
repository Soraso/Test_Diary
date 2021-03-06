package Intern::Diary::Model::Diary;

use strict;
use warnings;
use utf8;
use lib '/home/vpsuser/Test_Diary/lib';

use Class::Accessor::Lite(
	ro => [qw(
		diary_id
		user_id
		diary_name
		
	)],
	rw => [qw( entry user )],
	new => 1,
);

use Intern::Diary::Util;

sub created {
	my ($self) = @_;
	$self->{_created} ||= eval { Intern::Diary::Util::datetime_from_db(
		$self->{created}
	)};
}

1;
