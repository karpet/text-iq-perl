package Text::IQ;

use warnings;
use strict;
use Carp;
use Search::Tools::Tokenizer;
use Search::Tools::UTF8;
use Search::Tools::SpellCheck;
use File::Slurp;

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
    my $self  = bless {}, $class;
    my $text  = shift;
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
    $self->{_tokens} = $tokenizer->tokenize( $self->{_text} );
    return $self;
}

sub num_words {
    my $self = shift;
    return $self->{_tokens}->num_matches;
}

sub word_length {
    my $self = shift;
    return $self->{_word_len} if defined $self->{_word_len};
    my $n_words   = 0;
    my $total_len = 0;
    for my $t ( @{ $self->{_tokens}->matches } ) {
        $total_len += $t->u8len;
        $n_words++;
    }
    $self->{_word_len} = $total_len / $n_words;
    return $self->{_word_len};
}

sub num_sentences {
    my $self = shift;
    return $self->{_num_sentences} if defined $self->{_num_sentences};
    my $n = 0;
    while ( my $t = $self->{_tokens}->next ) {
        $n += $t->is_sentence_start;
    }
    $self->{_tokens}->reset;
    $self->{_num_sentences} = $n;
    return $n;
}

sub sentence_length {
    my $self = shift;
    return $self->{_sentence_len} if defined $self->{_sentence_len};
    my $n         = 0;
    my $total_len = 0;
    my $len       = 0;
    while ( my $t = $self->{_tokens}->next ) {
        if ( $t->is_sentence_start ) {
            $total_len += $len;
            $len = 0;
            $n++;
        }
        $len += $t->is_match;
    }
    $self->{_sentence_len} = $total_len / $n;
    $self->{_tokens}->reset;
    return $self->{_sentence_len};
}

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
