#!/usr/bin/perl

sub Hello {
   print "Hello, World!\n";
}

sub HelloParam {
  my @param = @_;
   print "Hello, @param!\n";
}

Hello();
HelloParam("friend");
