package constant::our::ENV;

use warnings;
use strict;

our $VERSION = '0.02';

my %constants;
BEGIN
{
    foreach ( keys %ENV )
    {
        if ( my ($name) = /^CONSTANT_OUR_(.*)/ )
        {
            $constants{$name} = $ENV{$_};
        }
    }
}
use constant::our \%constants;
1;

=head1 NAME

constant::our::ENV - define constants based on environment variables

=head1 SYNOPSIS

  BEGIN {
      $ENV{CONSTANT_OUR_DEBUG} = 1;
  }
  use constant::our::ENV;
  
  print "Running in debug mode\n" if DEBUG;

=head1 DESCRIPTION

This module looks for any environment variables whose name starts with
CONSTANT_OUR_, and defines constants using L<constant::our> for each
such variable.

=head1 SEE ALSO

L<constant::our>

=head1 AUTHOR

Green, E<lt>Evdokimov.Denis at gmail.comE<gt>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Green, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

