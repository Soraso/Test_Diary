package Intern::Diary::Service::Diary;

use strict;
use warnings;
use utf8;

use List::Util;
use Carp qw(croak);

use Intern::Diary::Util;
use Intern::Diary::Service::Entry;
use Intern::Diary::Model::Diary;

sub find_diary_by_user_id_and_diary_name{
	my ($class, $db, $args) = @_;
	
	my $user_id = $args->{user_id} // croak 'user_id required';
	my $diary_name = $args->{diary_name} // croak 'diary_name required';
	
	my $row = $db->select_row( q[
		SELECT * FROM diary
			WHERE user_id = ? AND diary_name = ?
		], $user_id, $diary_name) or return;
	
	return Intern::Diary::Model::Diary->new($row);
	
}


sub find_diaries_by_user{
	my ($class, $db, $args) = @_;
	
	my $user = $args->{user} // croak 'user required';
	
	my $per_page = $args->{per_page};
	my $page = $args->{page};
	my $order_by = $args->{order_by};
	
	my $opts = {};
	
	$opts->{limit} = $per_page
		if defined $per_page;
	$opts->{offset} = ($page - 1) * $per_page
		if defined $page && $per_page;
	$opts->{order_by} = $order_by
		if defined $order_by;
	
	
	my ($sql, @binds) = Intern::Diary::Util::query_builder->select('diary',['*'],{
		user_id => $user->user_id,
	},$opts);
	
	return [ map{
		Intern::Diary::Model::Diary->new($_);
	} @{$db->select_all($sql, @binds)}];
	
}

sub find_diaries_by_user_id{
	my($class, $db, $args) = @_;
	
	my $user = $args->{user} // croak 'user required';
	
	return [ map {
		Intern::Diary::Model::Diary->new($_);
	}@{$db->select_all(q[
		SELECT * FROM diary
			WHERE user_id = ?
	], $user->user_id ) } ]
}

sub load_entry_info{
	my ($class, $db, $diaries) = @_;
	
	my @diary_ids;
	
	for my $diary (@$diaries){
		my $id=$diary->{diary_id};
		push(@diary_ids,$id);
	}
	
	my $diary_ids_ref = \@diary_ids;
	
	my $entries = Intern::Diary::Service::Entry->find_entries_by_diary_ids($db, +{
		diary_ids	=> $diary_ids_ref
	});
	
	my @entry_array;
	
	for my $diary (@$diaries){
		for my $entry (@$entries){
			if(($diary->{diary_id}) == ($entry->{diary_id})){
				push(@entry_array, $entry);
				#print ("\n", $diary->{entry($entry_id)}->{title});
			}
		}
		$diary->{entry} = \@entry_array;
		#$diary->entry(first { $_->diary_id == $diary->{diary_id}} @$entries);
	}
	
	return $diaries;
}



sub create_diary{
	my ($class, $db, $args) = @_;
	
	my $user_id = $args->{user_id} // croak 'user_id required';
	my $diary_name = $args->{diary_name} // croak 'diary_name required';
	
	my $now = Intern::Diary::Util->now;
	
	$db->query(q[
		INSERT INTO diary(user_id, diary_name, created)
			VALUES(?)
	],[$user_id, $diary_name, $now]	);
}


1;