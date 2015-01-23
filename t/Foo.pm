package Foo;
use strict;use warnings;
use Class::Visibility;

sub new{return bless {}, shift;}

public 'public1';
protected 'protected1';
private 'private1';

sub get_protected_foo
{
    return shift->protected1;
}
sub set_protected_foo
{
    my( $self, $value) = @_;
    $self->protected1 = $value;
}

sub get_private_foo
{
    return my $var = shift->private1;
}
sub set_private_foo
{
    my( $self, $value) = @_;
    $self->private1 = $value;
}

1;
