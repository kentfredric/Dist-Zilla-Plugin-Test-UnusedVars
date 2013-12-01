use 5.008;
use strict;
use warnings;

package Dist::Zilla::Plugin::Test::UnusedVars;
# ABSTRACT: Release tests for unused variables
# VERSION
use Path::Tiny;
use Moose;
use Data::Section -setup;
with qw(
    Dist::Zilla::Role::FileGatherer
    Dist::Zilla::Role::TextTemplate
);

has files => (
    is  => 'ro',
    isa => 'Maybe[ArrayRef[Str]]',
    predicate => 'has_files',
);

=for Pod::Coverage *EVERYTHING*

=cut

sub mvp_multivalue_args { return qw/ files / }
sub mvp_aliases { return { file => 'files' } }

sub gather_files {
    my $self = shift;
    my $file = 'xt/release/unused-vars.t';

    require Dist::Zilla::File::InMemory;
    $self->add_file(
        Dist::Zilla::File::InMemory->new({
            name    => $file,
            content => $self->fill_in_string(
                ${ $self->section_data($file) },
                {
                    has_files => $self->has_files,
                    files => ($self->has_files
                        ? [ map { path($_)->relative('lib')->stringify } @{ $self->files } ]
                        : []
                    ),
                }
            ),
        })
    );
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;

=head1 SYNOPSIS

In C<dist.ini>:

    [Test::UnusedVars]

Or, give a list of files to test:

    [Test::UnusedVars]
    file = lib/My/Module.pm
    file = bin/verify-this

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

use Test::More 0.96 tests => 1;
eval { require Test::Vars };

SKIP: {
    skip 1 => 'Test::Vars required for testing for unused vars'
        if $@;
    Test::Vars->import;

    subtest 'unused vars' => sub {
{{
$has_files
    ? 'my @files = (' . "\n"
        . join(",\n", map { q{    '} . $_ . q{'} } map { s{'}{\\'}g; $_ } @files)
        . "\n" . ');' . "\n"
        . 'vars_ok($_) for @files;'
    : 'all_vars_ok();'
}}
    };
};
