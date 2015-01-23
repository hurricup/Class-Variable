package Class::Visibility;
use strict; use warnings FATAL => 'all'; 
use parent 'Exporter';
use 5.000000;
use Carp;
use Scalar::Util 'weaken';

our $VERSION = '1.000000';

our @EXPORT;

my $NS = {};

push @EXPORT, 'public';
sub public
{
    my @names = @_;
    my $package = (caller)[0];
    foreach my $name (@names)
    {
        no strict 'refs';
        *{$package.'::'.$name } = get_public_variable($package, $name);
    }
}

push @EXPORT, 'protected';
sub protected
{
    my @names = @_;
    my $package = (caller)[0];
    foreach my $name (@names)
    {
        no strict 'refs';
        *{$package.'::'.$name } = get_protected_variable($package, $name);
    }
}

push @EXPORT, 'private';
sub private
{
    my @names = @_;
    my $package = (caller)[0];
    foreach my $name (@names)
    {
        no strict 'refs';
        *{$package.'::'.$name } = get_private_variable($package, $name);
    }
}

sub get_public_variable($$)
{
    my( $package, $name ) = @_;
    
    return sub: lvalue
    {
        my $self = shift;
        if( 
            not exists $NS->{$self}
            or not defined $NS->{$self}->{' self'} 
        )
        {
            $NS->{$self} = {
                ' self' => $self
            };
            weaken $NS->{$self}->{' self'};
        }
        
        $NS->{$self}->{$name};
    };
}

sub get_protected_variable($$)
{
    my( $package, $name ) = @_;
    
    return sub: lvalue
    {
        my $self = shift;
        if( 
            not exists $NS->{$self}
            or not defined $NS->{$self}->{' self'} 
        )
        {
            $NS->{$self} = {
                ' self' => $self
            };
            weaken $NS->{$self}->{' self'};
        }
        
        croak sprintf(
            "Access violation: protected variable %s of %s available only to class or subclasses, but not %s."
            , $name
            , $package
            , caller ) if not caller->isa($package);
            
        $NS->{$self}->{$name};
    };
}

sub get_private_variable($$)
{
    my( $package, $name ) = @_;
    
    return sub: lvalue
    {
        my $self = shift;
        if( 
            not exists $NS->{$self}
            or not defined $NS->{$self}->{' self'} 
        )
        {
            $NS->{$self} = {
                ' self' => $self
            };
            weaken $NS->{$self}->{' self'};
        }
        
        croak sprintf(
            "Access violation: private variable %s of %s available only to class itself, not %s."
            , $name
            , $package
            , caller ) if caller ne $package;
            
        $NS->{$self}->{$name};
    };
}

1;
__END__
=head1 NAME

Class::Visibility - Perl implementation of class variables visibility limitation.

=head1 SYNOPSIS

  use Class::Visibility;

=head1 DESCRIPTION


=head1 BUGS AND IMPROVEMENTS

If you found any bug and/or want to make some improvement, feel free to participate in the project on GitHub: L<https://github.com/hurricup/Class-Visibility>

=head1 LICENSE

This module is published under the terms of the MIT license, which basically means "Do with it whatever you want". For more information, see the LICENSE file that should be enclosed with this distributions. A copy of the license is (at the time of writing) also available at L<http://www.opensource.org/licenses/mit-license.php>.

=head1 SEE ALSO

=over

=item * Main project repository and bugtracker: L<https://github.com/hurricup/Class-Visibility>

=item * See also: L<Class::Property>. 

=back

=head1 AUTHOR

Copyright (C) 2015 by Alexandr Evstigneev (L<hurricup@evstigneev.com|mailto:hurricup@evstigneev.com>)



=cut
