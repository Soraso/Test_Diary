package Intern::Diary::Service::Entry;

use strict;
use warnings;
use utf8;

use Carp qw(croak);

use Intern::Diary::Model::Entry;

sub find_entry_by_title_and_diary_id{
	my ($class, $db, $args) = @_;
	
	my $diary_id 	= $args->{diary_id} // croak 'diary_id reauired';
	my $title		= $args->{title}	// croak 'title required';
	
	
	my $row = $db->select_row( q[
		SELECT * FROM entry
			WHERE diary_id = ? AND title = ?
		], $diary_id, $title) or return;
	
	return Intern::Diary::Model::Entry->new($row);
	
}

sub find_entries_by_diary_ids{
	my ($class, $db, $args) = @_;
	
	my $diary_ids = $args->{diary_ids} // croak 'diary_ids required';

	return [] unless scalar @$diary_ids;
	
	[ map{
		Intern::Diary::Model::Entry->new($_);
	} @{$db->select_all(q[
		SELECT * FROM entry
			WHERE
				diary_id IN (?)
	], $diary_ids)} ];
	
}

sub find_entry_by_diary_id{
	my ($class, $db, $args) = @_;
	my $diary_id = $args->{diary_id} // croak 'diary_id required';
	
	return $class->find_entries_by_diary_ids($db, +{
		diary_ids => [$diary_id],
	})->[0];
	
}

sub find_entries_by_entry_ids{
	my($class, $db, $args) = @_;
	
	my $entry_ids = $args->{entry_ids} // croak 'entry_ids reauired';
	
	return [] unless scalar @$entry_ids;
	
	[map{
		Intern::Diary::Model::Entry->new($_);
	} @{$db->select_all(q[
		SELECT * FROM entry
			WHERE
				entry_id IN (?)
	], $entry_ids)} ];
}

sub find_entry_by_entry_id{
	my ($class, $db, $args) = @_;
	my $entry_id = $args->{entry_id} // croak 'entry_id required';
	
	return $class->find_entries_by_entry_ids($db, +{
		entry_ids => [$entry_id],
	})->[0];
	
}

sub delete_entry{

	my ($class, $db, $entry) = @_;
	
	$db->query(q[
		DELETE FROM entry
			WHERE
				entry_id = ?
	], $entry->entry_id);
	
	print "deleted\n";

}

sub delete_entry_by_diary_id_and_entry_id{
	my ($class, $db, $args) = @_;
	
	my $diary_id = $args->{diary_id}	// croak 'diary_id required';
	my $entry_id = $args->{entry_id}	// croak 'entry_id required';
	
	my $entry = $class->find_entry_by_entry_id($db, +{
		entry_id	=> $entry_id,
	});
	
	return [] unless defined $entry;
	
	$class->delete_entry($db, $entry);
	
	
}

sub add_entry{

	my ($class, $db, $args) = @_;
	my $diary_id = $args->{diary_id} // croak 'diary_id required';
	my $title = $args->{title} // '';
	my $entry_body = $args->{entry_body} // '';
	my $now = Intern::Diary::Util::now;
	
	my $entry = $db->query(q[
		INSERT INTO entry (diary_id, title, entry_body, created)
			VALUES(?)
	], [$diary_id, $title, $entry_body, $now]);
	
	
	my $newEntry = $class->find_entry_by_title_and_diary_id($db, +{
		diary_id	=> $diary_id,
		title		=> $title,
	});
	
	return $newEntry;
	
}

=put
#今の所使われておらず
sub find_or_add_entry_by_title{
	my ($class, $args) = @_;
	
	my $title = $args->{title} // croak 'title required';
	my $diary_id = $args->{diary_id} // croak 'diary_id required';
	my $entry_body = $args->{entry_body};
	
	my $entry = $class->find_entry_by_title_and_diary_id($db, +{ 
		diary_id	=> $diary_id,
		title		=> $title,
	});
	
	unless($entry) {
		my $makeEntry = $class->add_entry( $db, +{
			diary_id 	=> $diary_id,
			title		=> $title,
			entry_body	=> $entry_body,
		});
		$entry = $class->find_entry_by_title_and_diary_id($db, +{
			diary_id	=> $diary_id,
			title		=> $title,
		});
	}
}
=cut

1;