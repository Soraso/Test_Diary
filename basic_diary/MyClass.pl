#!/usr/bin/env perl
package MyModule;
use strict;
use warnings;
use utf8;
use MyClass;

my @list = (1, 2, 3, 4);
print MyClass::subroutine_sum(@list), "\n";
print MyClass->class_method_sum(\@list), "\n";
print MyClass->new(\@list)->instance_method_sum, "\n";