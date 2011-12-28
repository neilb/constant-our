#!perl -T

use Test::More tests => 2;

BEGIN {
    use_ok( 'constant::our' );
    use_ok( 'constant::our::ENV' );
}

diag( "Testing constant::our $constant::our::VERSION, Perl $], $^X" );
