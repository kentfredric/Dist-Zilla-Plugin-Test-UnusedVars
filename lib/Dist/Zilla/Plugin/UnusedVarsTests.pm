use 5.008;
use strict;
use warnings;

package Dist::Zilla::Plugin::UnusedVarsTests;
# ABSTRACT: (DEPRECATED) Release tests for unused variables
# VERSION
use Moose;
use namespace::autoclean;
extends 'Dist::Zilla::Plugin::Test::UnusedVars';

before register_component => sub {
    warn '!!! [UnusedVarsTests] is deprecated and will be removed in a future release; replace it with [Test::UnusedVars]';
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;

=head1 SYNOPSIS

Please use L<Dist::Zilla::Plugin::Test::UnusedVars> instead.

In C<dist.ini>:

    [Test::UnusedVars]

=for test_synopsis
1;
__END__

=cut
