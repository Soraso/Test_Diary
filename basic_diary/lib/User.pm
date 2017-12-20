# Programming/Test_Diary/basic_diary/lib

package User;
use strict;
use warnings;
use utf8;


sub add_entry{
	my $self = shift;
	$self->{'Title'}=$_[1];
	$self->{'Body'}=$_[3];
	
	return $self;
	
}

sub add_diary{
	my $self = shift;
	$self->{Name}=$_[1];

	return $self;
}


sub get_recent_entries{
	my $self = shift;
	my $title = $self->{Title};
	my $body = $self->{Body};
	return ($title,$body);
}

sub new{

	my $class = shift;
	my $self = {User => undef};
	if(@_){
		$self = {User => $_[1]};
	}
	$self->{Name} = undef;

	$self->{Title}=undef;
	$self->{Body}=undef;
	
	bless $self,$class;
	#bless @title,$class;
	#bless @body,$class;
	
	return $self;
}


1;