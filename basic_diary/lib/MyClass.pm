#!/usr/bin/env perl
package MyClass;
use strict;
use warnings;
use utf8;

sub subroutine_sum {
    my $r = 0;
    $r += $_ foreach (@_);
    $r;
}

sub class_method_sum {
    my $class = shift;
    subroutine_sum @{shift()};
}

sub instance_method_sum {
    my $self = shift;
    subroutine_sum @{$self->{list}};
}

sub new {
    my $class = shift;
    my $list = shift;
    bless {list => $list}, $class;
}

1;