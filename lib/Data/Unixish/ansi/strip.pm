package Data::Unixish::ansi::strip;

use 5.010;
use strict;
use syntax 'each_on_array'; # to support perl < 5.12
use warnings;
#use Log::Any '$log';

use Data::Unixish::Util qw(%common_args);
use Text::ANSI::Util qw(ta_strip);

our $VERSION = '0.04'; # VERSION

our %SPEC;

$SPEC{strip} = {
    v => 1.1,
    summary => 'Strip ANSI codes (colors, etc) from text',
    args => {
        %common_args,
    },
    tags => [qw/text ansi itemfunc/],
    "x.perinci.cmdline.default_format" => "text-simple",
};
sub strip {
    my %args = @_;
    my ($in, $out) = ($args{in}, $args{out});

    while (my ($index, $item) = each @$in) {
        push @$out, _strip_item($item);
    }

    [200, "OK"];
}

sub _strip_item {
    my $item = shift;
    {
        last if !defined($item) || ref($item);
        $item = ta_strip($item);
    }
    return $item;
}

1;
# ABSTRACT: Strip ANSI codes (colors, etc) from text

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::Unixish::ansi::strip - Strip ANSI codes (colors, etc) from text

=head1 VERSION

version 0.04

=head1 SYNOPSIS

In Perl:

 use Data::Unixish qw(lduxl);
 $stripped = lduxl('ansi::strip', "\e[1mblah"); # "blah"

In command line:

 % echo -e "\e[1mHELLO";                   # text will appear in bold
 % echo -e "\e[1mHELLO" | dux ansi::strip; # text will appear normal
 HELLO

=head1 FUNCTIONS


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
