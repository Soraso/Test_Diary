
use strict;
use warnings;
use utf8;

use Encode qw(encode_utf8 decode_utf8);
use pod::Usage;

use FindBin;
use lib "$FindBin::Bin/../lib";

use DBIx::Sunny;

use Intern::Diary::Config;
use Intern::Diary::Service::User;
use Intern::Diary::Service::Entry;


BEGIN { $ENV{INTERN_DIARY_ENV} = 'local'};

my %HANDLERS = (
	#make	=> \&make_diary,
	add		=> \&add_entry,
	#list 	=> \&list_entry,
	#delete 	=> \&delete_entry,
);

my $name 		= shift @ARGV;
my $command 	= shift @ARGV;
#@ARGV : arguments which are given before this pl program run

my $db	= do{
	my $config = config->param('db')->{intern_diary};
	DBIx::Sunny->connect(map {$config->{$_} } qw(dsn user password));
};

my $user = Intern::Diary::Service::User->find_user_by_name($db, +{ name => $name});
unless ($user){
	$user = Intern::Diary::Service::User->create($db, +{ name => $name});
}

my $handler = $HANDLERS{ $command } or pod2usage;
$handler->($user, @ARGV);


exit 0;

sub add_entry{
	my ($user, $title, $entry_body) = @_;
	
	my $diary = Intern::Diary::Service::Diary->add_entry($db, +{
		user		=> $user,
		title		=> decode_utf8 $title,
		entry_body	=> decode_utf8 $entry_body,
	});
	
	print 'wrote diary ' . encode_utf8($diary->{entry}->title) . ' ' . encode_utf8($diary->entry_body) . "\n";
	
}
=pod
sub list_entry{
	my ($user) = @_;
	
	printf "--- %s's Diaries ---\n", $user->name;
	
	my $diaries = Intern::Diary::Service::Diary->find_entry_by_user($db, +{
		user => $user,
	});
	$diaries = Intern::Diary::Service::Diary->load_entry_info($db, $diaries);
	
	foreach my $diary (@$diaries){
		print $diary->entry_id . $diary->{entry}->title . ' ' . $diary->{entry}->entry_body . "\n";
	}

}

sub delete_bookmark {
	my ($user, $entry_id) = @_;
	
	die 'entry id required' unless defined $entry_id;
	
	my $diary = Intern::Diary::Service::Diary->delete_diary_by_entry_id($db, +{
		user => $user,
		entry_id => $entry_id,
	});
	
	print "Deleted \n";
}
=cut

__END__

=head1 NAME

diary.pl - my diary

=head1 SYNPSIS
	diary.pl user_name add title entry-body
	
=cut