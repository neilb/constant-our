package constant::our;

use warnings;
use strict;

=head1 NAME

constant::our - Perl pragma to declare constants like our vars

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

use constant;
use Exporter;

our @EXPORT_OK;
our %values;

my $reserved_text = "Reserved for " . __PACKAGE__;
our %reserved_constant = (
                           import                       => $reserved_text,
                           _constant_our_set            => $reserved_text,
                           _constant_our_check_reserved => $reserved_text,
);

################################################################################
sub import
{
    my ( $class, @args ) = @_;
    unless (@args)
    {
        return;
    }

    my $set_hash;

    if ( ref $args[0] )
    {
        $set_hash = shift @args;
        unless ( ref $set_hash eq 'HASH' && @args == 0 )
        {
            die __PACKAGE__ . " must call with one hash ref";
        }
        @_ = ( $class, keys %$set_hash );
    }
    else
    {
        foreach (@args)
        {
            unless ( exists $values{$_} )
            {
                $set_hash->{$_} = undef;
            }
        }
    }
    if ( $set_hash && %$set_hash )
    {
        __PACKAGE__->_constant_our_set($set_hash);
    }
    goto &Exporter::import;
}
################################################################################
sub _constant_our_set
{
    my $class = shift;
    my %set;
    if ( ref $_[0] )
    {
        %set = %{ $_[0] };
    }
    else
    {
        %set = @_;
    }

    _constant_our_check_reserved( keys %set );
    foreach ( keys %set )
    {
        if ( exists $values{$_} )
        {
            if ( defined $values{$_} && defined $set{$_} && $values{$_} eq $set{$_} )
            {
                delete $set{$_};
            }
            elsif ( !defined $values{$_} && !defined $set{$_} )
            {
                delete $set{$_};
            }
            else
            {
                die "Flag [$_] set in 2 unmatched value: [$values{$_}] and [$set{$_}]";
            }
        }
        else
        {
            $values{$_} = $set{$_};
            push @EXPORT_OK, $_;
        }
    }

    if (%set)
    {
        __PACKAGE__->constant::import( \%set );
    }
}
################################################################################
sub _constant_our_check_reserved
{
    foreach (@_)
    {
        if ( exists $reserved_constant{$_} )
        {
            die "You can't use reserved constant[$_]: $reserved_constant{$_}";
        }
    }
}
################################################################################
1;    # End of constant::our

__END__

=head1 SYNOPSIS

    use constant::our { DEBUG => 1 };
    use constant::our {
        DEBUG_SQL => 1,
        DEBUG_CACHE => 1,
    };

    ######################
    package My::Cool::Tools;
    use constant::our qw(DEBUG DEBUG_SQL);

    if(DEBUG)
    {
        warn "DEBUG: $debug_info";
        if(DEBUG_SQL)
        {
            warn "DEBUG_SQL: $querty";
        }
    }

    # or
    DEBUG && warn "DEBUG: $debug_info";
    DEBUG && DEBUG_SQL && warn "DEBUG_SQL: $querty";

=head1 DESCRIPTION

    This pragma extends standard pragma 'constant'.

    As you may know, when a constant is used in an expression, Perl replaces it with its value at compile time, and may
    then optimize the expression further. 

    You can inspect this behavior by yourself:

        $ perl -MO=Deparse -e'use constant{DEBUG => 1}; warn "1"; if(DEBUG){warn "2"} warn 3;'
        use constant ({'DEBUG', 1});
        warn '1';
        do {
            warn '2'
        };
        warn 3;

    All warns are here.

        $ perl -MO=Deparse -e'use constant{DEBUG => 0}; warn "1"; if(DEBUG){warn "2"} warn 3;'
        use constant ({'DEBUG', 0});
        warn '1';
        '???'; 
        warn 3;

    Notice the '???' instead of the second 'warn'. 
    
    So you can do something like this: 

        # in the main script
        use constant DEBUG => 0;

        # in a module
        if(main::DEBUG)
        {
            # some debug code goes here
        }

    But you should declare all constants you use, you can't simply write 

        if(main::DEBUG_SQL)
        {
        }

    without corresponding 

        use constant DEBUG_SQL => 0;

    in the main script.

    With constant::our you can freely use "undeclared" constants in your condition statements. 

        # main script
        use constant::our {
            DEBUG => 1,
            DEBUG_CACHE => 1,
        };

        ######################
        package My::Cool::Tools;
        use constant::our qw(DEBUG DEBUG_SQL); # don't need DEBUG_CACHE, but want (undeclared) DEBUG_SQL

        DEBUG && warn "DEBUG: $debug_info";              # DEBUG --> 1 
        DEBUG && DEBUG_SQL && warn "DEBUG_SQL: $query";  # DEBUG_SQL --> undef

    stderr: 
    "DEBUG: ..."


=head1 IMPORTANT

    A constant should be declared no more than one time. If you try to declare a constant twice (with different values), your program will die. 

    Since use of undeclared constant implicitly declares it, you should declare your constants _before_ you start use them. 

=head1 EXPORT

    Nothing by default.

=head1 SEE ALSO

L<constant>

L<constant::abs> && L<constant::def>


=head1 AUTHOR

Green, C<< <Evdokimov.Denis at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-constant-our at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=constant::our>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc constant::our

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=constant::our>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/constant::our>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/constant::our>

=item * Search CPAN

L<http://search.cpan.org/dist/constant::our>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2009 Green, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut
