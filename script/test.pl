
use strict;
use warnings;
use utf8;

use Encode qw(encode_utf8 decode_utf8);
use pod::Usage;

use FindBin;
use lib "$FindBin::Bin/../lib";

use DBIx::Sunny;
use DBI;

use Intern::Diary::Config;
use Intern::Diary::Service::Diary;
use Intern::Diary::Service::User;
use Intern::Diary::Service::Entry;

BEGIN { $ENV{INTERN_BOOKMARK_ENV} = 'local' };

my %HANDLERS = (
	#make	=> \&make_diary,
	add		=> \&add_entry,
	list 	=> \&list_diaries,
	#delete 	=> \&delete_entry,
	create	=> \&create_diary
);

my $name 		= shift @ARGV;
my $command 	= shift @ARGV;
#@ARGV : arguments which are given before this pl program run


my $db 			=  do{
	#my $config = config->param('db')->{intern_diary};
	DBIx::Sunny->connect("DBI:mysql:database=test_diary:host=localhost:port=3306",
	"root","Root"
	) or die "cannot connect to Mysql: $DBI::errstr";
};

my $user = Intern::Diary::Service::User->find_user_by_name($db, +{ name => $name});
unless ($user){
	$user = Intern::Diary::Service::User->create($db, +{ name => $name});
	print "create user";
}

my $handler = $HANDLERS{ $command };
$handler->($user, @ARGV);

exit 0;

sub create_diary{

	my($user, $diary_name) = @_;
	
	my $diary = Intern::Diary::Service::Diary->create_diary($db, +{
		user_id 		=> $user->{user_id},
		diary_name 	=> $diary_name,
	});

}


sub add_entry{

	my ($user, $diary_name, $title, $entry_body) = @_;
	
	my $diary = Intern::Diary::Service::Diary->find_diary_by_user_id_and_diary_name($db, +{
		user_id		=> $user->{user_id},
		diary_name	=> $diary_name,
	});
	
	#print ("\n", $diary->{diary_id});
	#print ("\n", $diary->{diary_name});

	my $entry = Intern::Diary::Service::Entry->add_entry($db, +{
		diary_id	=> $diary->{diary_id},
		title		=> $title,
		entry_body	=> decode_utf8 $entry_body,
	});
	
	
	print "<wrote diary>\n";
	print ("diary_id\t", $entry->{entry_id},"\n");
	print ("Title\t\t", $entry->{title} , "\n");
	print ("Body\t\t", $entry->{entry_body}, "\n");

}


sub list_diaries{
	my ($user) =@_;
	
	printf "--- %s's Diaries ---\n" , $user->name;
	
	my $diaries = Intern::Diary::Service::Diary->find_diaries_by_user($db, +{
		user => $user,
	});
	
	
	my $diaries_info = Intern::Diary::Service::Diary->load_entry_info($db, $diaries);
	
	foreach my $diary (@$diaries){
		my $diary_id = $diary->{diary_id};
		my $diary_name = $diary->{diary_name};
		my $created = $diary->{created};
		
		print "\n";
		print ( "Diary id       " , $diary_id,  "\n");
		print ( "Diary Name     " , $diary_name, "\n");
		print ( "Created Date   " , $created, "\n");
		
		my $entries = $diary->{entry};
		
		for my $entry (@$entries){
			print "\n";
			print ( "Entry_id       ", $entry->{entry_id}, "\n");
			print ( "Title          ", $entry->{title}, "\n");
			print ( "Entry_body     ", $entry->{entry_body}, "\n");
			print ( "Created Date   ", $entry->{created}, "\n");
			print ( "Updated Date   ", $entry->{updated}, "\n");
		}
		
		
		
	}
	
	
}

print "finish";

__END__

=head1 NAME
bookmark.pl - my bookmark

=head1 SYNOPSIS
  perl test.pl Taro add Title Entry_body
  perl test.pl Taro list
  perl test.pl Taro create Diary_Twooooo
=cut