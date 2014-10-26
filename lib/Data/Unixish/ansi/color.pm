package Data::Unixish::ansi::color;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);
use Term::ANSIColor qw();

our $VERSION = '0.04'; # VERSION

our %SPEC;

$SPEC{color} = {
    v => 1.1,
    summary => 'Colorize text with ANSI color codes',
    args => {
        %common_args,
        color => {
            schema => 'str*',
            summary => 'The color to use for each item',
            description => <<'_',

Example: `red`, `bold blue`, `yellow on_magenta`, `black on_bright_yellow`. See
Perl module Term::ANSIColor for more details.

You can also supply raw ANSI code.

_
            req => 1,
            pos => 0,
            cmdline_aliases => { c=>{} },
        },
    },
    tags => [qw/text ansi itemfunc/],
    "x.perinci.cmdline.default_format" => "text-simple",
};
sub color {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});

    _color_begin(\%args);
    while (my ($index, $item) = each @$in) {
        push @$out, _color_item($item, \%args);
    }

    [200, "OK"];
}

sub _color_begin {
    my $args = shift;

    # abuse args to store state
    my $color = $args->{color};
    $color = Term::ANSIColor::color($color) unless $color =~ /\A\e/;
    $args->{_color} = $color;
}

sub _color_item {
    my ($item, $args) = @_;

    {
        last if !defined($item) || ref($item);
        $item = $args->{_color} . $item . "\e[0m";
        #$log->tracef("item=%s, color=%s", $item, $args->{_color});
    }
    return $item;
}

1;
# ABSTRACT: Colorize text with ANSI color codes

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Unixish::ansi::color - Colorize text with ANSI color codes

=head1 VERSION

version 0.04

=head1 SYNOPSIS

In Perl:

 use Data::Unixish qw(lduxl);
 $colorized = lduxl(['ansi::color' => {color=>"red"}], "red"); # "\e[31mred\e[0m"

In command line:

 % echo -e "HELLO" | dux ansi::color --color red; # text will appear in red
 HELLO

=head1 FUNCTIONS


=head2 color(%args) -> [status, msg, result, meta]

Colorize text with ANSI color codes.

Arguments ('*' denotes required arguments):

=over 4

=item * B<color>* => I<str>

The color to use for each item.

Example: C<red>, C<bold blue>, C<yellow on_magenta>, C<black on_bright_yellow>. See
Perl module Term::ANSIColor for more details.

You can also supply raw ANSI code.

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

=back

Return value:

Returns an enveloped result (an array).

First element (status) is an integer containing HTTP status code
(200 means OK, 4xx caller error, 5xx function error). Second element
(msg) is a string containing error message, or 'OK' if status is
200. Third element (result) is optional, the actual result. Fourth
element (meta) is called result metadata and is optional, a hash
that contains extra information.

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Data-Unixish-ansi>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-Data-Unixish-ansi>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=Data-Unixish-ansi>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
