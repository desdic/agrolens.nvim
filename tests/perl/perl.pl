#!/usr/bin/perl

sub Hello {
   print "Hello, World!\n";
}

=for comment
stuff
=cut
sub HelloParam {
  my @param = @_;
   print "Hello, @param!\n";
}

Hello();
HelloParam("friend");
