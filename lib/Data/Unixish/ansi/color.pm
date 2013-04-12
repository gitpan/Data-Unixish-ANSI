package Data::Unixish::ansi::color;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);
use Term::ANSIColor qw();

our $VERSION = '0.01'; # VERSION

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
        },
    },
    tags => [qw/text ansi/],
    "x.dux.default_format" => "text-simple",
};
sub color {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});

    my $color = $args{color};
    $color = Term::ANSIColor::color($color) unless $color =~ /\A\e/;

    while (my ($index, $item) = each @$in) {
        {
            last if !defined($item) || ref($item);
            $item = $color . $item . "\e[0m";
        }
        push @$out, $item;
    }

    [200, "OK"];
}

1;
# ABSTRACT: Colorize text with ANSI color codes



__END__
=pod

=encoding utf-8

=head1 NAME

Data::Unixish::ansi::color - Colorize text with ANSI color codes

=head1 VERSION

version 0.01

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::List qw(dux);
 $colorized = dux(['color' => {color=>"red"}], "red"); # "\e[31mred\e[0m"

In command line:

 % echo -e "HELLO" | dux ansi::color --color red; # text will appear in red
 HELLO

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DESCRIPTION

=head1 FUNCTIONS


None are exported by default, but they are exportable.

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

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut

