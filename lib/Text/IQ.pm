package Text::IQ;

use warnings;
use strict;
use Carp;
use Search::Tools::Tokenizer;
use Search::Tools::UTF8;
use Search::Tools::SpellCheck;
use File::Slurp;
use Data::Dump qw( dump );
use Scalar::Util qw( blessed );

our $VERSION = '0.001';

=head1 NAME

Text::IQ - naive intelligence about a body of text

=head1 SYNOPSIS

 use Text::IQ::EN;  # English text
 my $file = 'path/to/file';
 my $iq = Text::IQ::EN->new( $file );
 printf("Number of words: %d\n", $iq->num_words);
 printf("Avg word length: %d\n", $iq->word_length);
 printf("Number of sentences: %d\n", $iq->num_sentences);
 printf("Avg sentence length: %d\n", $iq->sentence_length);
 printf("Misspellings: %d\n", $iq->num_misspellings);
 printf("Grammar errors: %d\n", $iq->num_grammar_errors);
 
 # access internal Search::Tools::TokenList
 my $tokens = $iq->tokens;

=cut

sub new {
    my $class = shift;
    my $self  = bless {
        num_words             => 0,
        total_word_length     => 0,
        num_sentences         => 0,
        total_sentence_length => 0,
        tmp_sent_len          => 0,
    }, $class;
    my $text = shift;
    if ( !defined $text ) {
        croak "text required";
    }
    if ( ref $text eq 'SCALAR' ) {
        $self->{_text} = to_utf8($$text);
    }
    else {
        $self->{_text} = to_utf8( scalar read_file($text) );
    }
    my $tokenizer = Search::Tools::Tokenizer->new();
    $self->{_tokens}
        = $tokenizer->tokenize( $self->{_text}, sub { $self->examine(@_) }, );
    $self->{avg_word_length}
        = $self->{total_word_length} / $self->{num_words};
    $self->{avg_sentence_length}
        = $self->{total_sentence_length} / $self->{num_sentences};
    return $self;
}

sub examine {
    my $self  = shift;
    my $token = shift;
    $self->{num_words}++;
    $self->{total_word_length} += $token->u8len;
    if ( $token->is_sentence_start ) {
        $self->{num_sentences}++;
        $self->{total_sentence_length} += $self->{tmp_sent_len};
        $self->{tmp_sent_len} = 0;
    }
    $self->{tmp_sent_len}++;
}

sub num_words       { shift->{num_words} }
sub num_sentences   { shift->{num_sentences} }
sub word_length     { shift->{avg_word_length} }
sub sentence_length { shift->{avg_sentence_length} }

1;

__END__

=head1 AUTHOR

Peter Karman, C<< <karman at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-text-iq at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Text-IQ>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Text::IQ

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Text-IQ>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Text-IQ>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Text-IQ>

=item * Search CPAN

L<http://search.cpan.org/dist/Text-IQ/>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2011 Peter Karman.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut
