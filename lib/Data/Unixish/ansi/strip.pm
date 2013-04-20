package Data::Unixish::ansi::strip;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);
use Text::ANSI::Util qw(ta_strip);

our $VERSION = '0.02'; # VERSION

our %SPEC;

$SPEC{strip} = {
    v => 1.1,
    summary => 'Strip ANSI codes (colors, etc) from text',
    args => {
        %common_args,
    },
    tags => [qw/text ansi/],
    "x.dux.default_format" => "text-simple",
};
sub strip {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});

    while (my ($index, $item) = each @$in) {
        {
            last if !defined($item) || ref($item);
            $item = ta_strip($item);
        }
        push @$out, $item;
    }

    [200, "OK"];
}

1;
# ABSTRACT: Strip ANSI codes (colors, etc) from text



__END__
=pod

=encoding utf-8

=head1 NAME

Data::Unixish::ansi::strip - Strip ANSI codes (colors, etc) from text

=head1 VERSION

version 0.02

=head1 SYNOPSIS

In Perl:

 use Data::Unixish::List qw(dux);
 $stripped = dux('ansi::strip', "\e[1mblah"); # "blah"

In command line:

 % echo -e "\e[1mHELLO";                   # text will appear in bold
 % echo -e "\e[1mHELLO" | dux ansi::strip; # text will appear normal
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

=head2 strip(%args) -> [status, msg, result, meta]

Strip ANSI codes (colors, etc) from text.

Arguments ('*' denotes required arguments):

=over 4

=item * B<in> => I<any>

Input stream (e.g. array or filehandle).

=item * B<out> => I<any>

Output stream (e.g. array or filehandle).

=back

Return value:

Returns an enveloped result (an array). First element (status) is an integer containing HTTP status code (200 means OK, 4xx caller error, 5xx function error). Second element (msg) is a string containing error message, or 'OK' if status is 200. Third element (result) is optional, the actual result. Fourth element (meta) is called result metadata and is optional, a hash that contains extra information.

=cut

