package constant::our::ENV;

use warnings;
use strict;

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
