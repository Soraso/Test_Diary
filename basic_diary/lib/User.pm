# Programming/Test_Diary/basic_diary/lib

package User;
use strict;
use warnings;
use utf8;


=pod
sub add_diary{
	my ($user,$name) = @_;
	my $self = { name => $name}
	$bless $self,$user;
}

sub add_entry{

}

sub get_recent_entries{

}
=cut


sub new{

	my $class = shift;
	my $user = shift;
	
	my $self = {$user => shift};
	
	#$self->{NAME} = undef;
	#$self->{entry} = [];
	
	bless $self,$class;
	
	print "\nWellcome Username = ",$self->{$user}, "\n";
	
	return $self;
}


1;