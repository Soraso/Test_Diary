use strict;
use warnings;

use User;

my $user1 = User->new(name => 'John');

# Diary class
my $diary = $user1->add_diary(
	name => 'John Diary.',
);

print $diary->name; #'John Diary'


#Entry class
my $entry1 = $diary->add_entry(
	title => 'This is Diary',
	body  => 'This is the body part of Diary',
);

my $entry2 = $diary->add_entry(
	title => 'This is secound entry',
	body  => 'This is the body of secoundary entry',
);

my $recent_entries = $diary->get_recent_entries;
print $recent_entries->body;#'This is the body of secoundary entry'
