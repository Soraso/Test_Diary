package Intern::Diary::View::Xslate;

use strict;
use warnings;
use utf8;

use lib '/home/vpsuser/Test_Diary/lib';

use Intern::Diary::Config;

use Text::Xslate ();

our $tx = Text::Xslate->new(
	path		=> [ config->root->subdir('templates') ],
	cache		=> 0,
	cache_dir	=> config->root->subdir(qw(tmp xslate)),
	syntax		=> 'TTerse',
	module		=> [ qw(Text::Xslate::Bridge::TT2Like) ],
	function	=> {
	},
);

sub render_file {
	
}
