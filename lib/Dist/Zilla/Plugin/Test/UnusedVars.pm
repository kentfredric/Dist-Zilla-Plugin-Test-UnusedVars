use 5.008;
use strict;
use warnings;

package Dist::Zilla::Plugin::Test::UnusedVars;
# ABSTRACT: Release tests for unused variables
# VERSION
use Moose;
extends 'Dist::Zilla::Plugin::InlineFiles';

__PACKAGE__->meta->make_immutable;
no Moose;
1;

=head1 SYNOPSIS

In C<dist.ini>:

    [Test::UnusedVars]

=for test_synopsis
1;
__END__

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following file:

  xt/release/unused-vars.t - a standard Test::Vars test

=cut

__DATA__
___[ xt/release/unused-vars.t ]___
#!perl

use Test::More;

eval "use Test::Vars";
plan skip_all => "Test::Vars required for testing unused vars"
  if $@;
all_vars_ok();
