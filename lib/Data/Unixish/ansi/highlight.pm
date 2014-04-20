package Data::Unixish::ansi::highlight;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);
use Term::ANSIColor;
use Text::ANSI::Util qw(ta_highlight_all);

our $VERSION = '0.04'; # VERSION

our %SPEC;

$SPEC{highlight} = {
    v => 1.1,
    summary => 'Highlight string/pattern with color',
    args => {
        %common_args,
        string => {
            summary => 'String to search',
            schema  => 'str*',
            cmdline_aliases => { s=>{} },
            description => <<'_',

Either this or `pattern` is required.

_
            pos => 0,
        },
        pattern => {
            summary => 'Regex pattern to search',
            schema  => ['str*', is_re=>1],
            cmdline_aliases => { p=>{} },
            description => <<'_',

Either this or `string` is required.

_
        },
        ci => {
            summary => 'Whether to search case-insensitively',
            schema  => ['bool', default=>0],
            cmdline_aliases => { i=>{} },
        },
        color => {
            summary => 'The color to use for each item',
            schema => ['str*', default => 'bold red'],
            description => <<'_',

Example: `red`, `bold blue`, `yellow on_magenta`, `black on_bright_yellow`. See
Perl module Term::ANSIColor for more details.

You can also supply raw ANSI code.

_
            cmdline_aliases => { c=>{} },
        },
    },
    tags => [qw/text ansi itemfunc/],
    "x.perinci.cmdline.default_format" => "text-simple",
};
sub highlight {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});

    return [400, "Please specify string or pattern"]
        unless defined($args{pattern}) || defined($args{string});

    _highlight_begin(\%args);
    while (my ($index, $item) = each @$in) {
        push @$out, _highlight_item($item, \%args);
    }

    [200, "OK"];
}

sub _highlight_begin {
    my $args = shift;

    # abuse args to store state
    my $color = $args->{color} // 'bold red';
    $color = color($color) unless $color =~ /\A\e/;
    $args->{_color} = $color;

    my $re;
    if (defined($args->{string})) {
        $re = $args->{ci} ?
            qr/\Q$args->{string}\E/io : qr/\Q$args->{string}\E/o;
    } elsif (defined($args->{pattern})) {
        $re = $args->{ci} ?
            qr/$args->{pattern}/io : qr/$args->{pattern}/o;
    } else {
        die "Please specify 'string' or 'pattern'";
    }
    $args->{_re} = $re;
}

sub _highlight_item {
    my ($item, $args) = @_;

    {
        last if !defined($item) || ref($item);
        $item = ta_highlight_all($item, $args->{_re}, $args->{_color});
    }
    return $item;
}

1;
# ABSTRACT: Highlight string/pattern with color

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Unixish::ansi::highlight - Highlight string/pattern with color

=head1 VERSION

version 0.04

=head1 SYNOPSIS

In Perl:

 use Data::Unixish qw(lduxl);
 $hilited = lduxl(['ansi::highlight' => {string=>"er"}], "merah"); # "m\e[31m\e[1mer\e[0mah"

In command line:

 % echo -e "merah" | dux ansi::highlight -s er; # 'er' will be highlighted
 merah

=head1 FUNCTIONS


=head2 highlight(%args) -> [status, msg, result, meta]

Highlight string/pattern with color.

Arguments ('*' denotes required arguments):

=over 4

=item * B<ci> => I<bool> (default: 0)

Whether to search case-insensitively.

=item * B<color> => I<str> (default: "bold red")

The color to use for each item.

Example: C<red>, C<bold blue>, C<yellow on_magenta>, C<black on_bright_yellow>. See
Perl module Term::ANSIColor for more details.

You can also supply raw ANSI code.

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

=item * B<pattern> => I<str>

Regex pattern to search.

Either this or C<string> is required.

=item * B<string> => I<str>

String to search.

Either this or C<pattern> is required.

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
