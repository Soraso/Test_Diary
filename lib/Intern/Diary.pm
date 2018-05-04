package Intern::Diary;

use strict;
use warnings;
use utf8;

use lib '/home/vpsuser/Test_Diary/lib';

use Class::Load qw(load_class);

use Intern::Diary::Config;
use Intern::Diary::Context;

sub as_psgi{
	my $class = shift;
	return sub {
		my $env = shift;
		return $class->run($env);
	};
}

sub run{
	my ($class, $env) =@_;
	my $context = Intern::Diary::Context->from_env($env);
	my $route = Intern::Diary::Congif->router->match($env)
		or $context->throw(404);
	$context->req->path_parameters(%{$route->{parameters}});
	
	my $destination = $route->{destination}
		or $context->throw(404);
	$destination->{engine}
		or $context->throw(404);
	
	my $engine = join '::', __PACKAGE__, 'Engine', $destination->{engine};
	my $action = $destination->{action} || 'default';
	my $dispatch = "$engine#$action";

	load_class $engine;
	
	my $handler = $engine->can($action)
		or $context->throw(501);
	$engine->$handler($context);

	$context->res->headers->header(X_Dispatch => $dispatch);
	return $context->res->finalize;
	
}

1;
