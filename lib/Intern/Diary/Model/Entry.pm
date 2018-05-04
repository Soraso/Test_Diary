package Intern::Diary::Model::Entry;

use strict;
use warnings;
use utf8;

use lib '/home/vpsuser/Test_Diary/lib';

use Class::Accessor::Lite(
	ro => [qw(
		entry_id
		diary_id
		title
		entry_body
	)],
	new => 1,
);

sub created {
	my($self) = @_;
	$self->{_created} ||= eval { Intern::Diary::Util::datetime_from_db(
		$self->{created}
	)};
}

sub update{
	my ($self) = @_;
	$self->{_updated} ||= eval { Intern::Diary::Util::datetime_from_db(
		$self->{updated}
	)};
}

1;
