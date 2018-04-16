use strict;
use warnings;

use User;

my $user1 = User->new(User => 'John');

print "\nYour User Name is ", $user1->{User},"\n";


# Diary class
my $diary = $user1->add_diary(
	name => 'John Diary',
);

print "\nDiary Name is ", $diary->{Name},"\n"; #'John Diary'


#Entry class
my $entry1 = $diary->add_entry(
	title => 'This is Diary',
	body  => 'This is the body part of Diary',
);

print "\nTitle = ",$entry1->{'Title'},"\n";
print "\nBody = ",$entry1->{'Body'},"\n";


my $entry2 = $diary->add_entry(
	title => 'This is secound entry',
	body  => 'This is the body of secoundary entry',
);

print "\nTitle = ",$entry2->{'Title'},"\n";
print "\nBody = ",$entry2->{'Body'},"\n";


my @recent_entries = $diary->get_recent_entries;
print "\nTitle :",$recent_entries[0],"\n";#'This is the body of secoundary entry'
print "Body  :",$recent_entries[1],"\n";