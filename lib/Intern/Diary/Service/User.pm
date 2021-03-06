package Intern::Diary::Service::User;

use strict;
use warnings;
use utf8;

use Carp qw(croak);

use Intern::Diary::Model::User;
use Intern::Diary::Util;

sub find_or_create_user_by_name{
	my( $class, $db, $args) = @_;
	return $class->find_user_by_name($db, $args) // $class->create($db, $args);
}

sub find_user_by_name{
	my( $class, $db, $args )= @_;
	
	my $name = $args->{name} // croak 'name required';
	
	my $row = $db->select_row(q[
		SELECT * FROM user
			WHERE name = ?
	], $name) or return;
	return Intern::Diary::Model::User->new($row)
}
=pod
sub find_users_by_user_ids{
	my ($class, $db, $args) = @_;
	my $user_ids = $args->{user_ids} // croak 'user_ids required';
	return [] unless scalar @$user_ids;
	
	return [ map {
		Intern::Diary::Model::User->new($_);
	}@{$db->select_all(q[
		SELECT * FROM user
			WHERE user_id IN (?)
	], $user_ids)}];
}
=cut
sub create{
	my ($class, $db, $args) = @_;
	
	my $name = $args->{name} // croak 'name required';
	
	$db->query(q[
		INSERT INTO user (name, created)
			VALUES(?)
	],[ $name, Intern::Diary::Util::now]);
	
	return $class->find_user_by_name($db, {
		name=> $name,
	});
}

1;