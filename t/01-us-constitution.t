#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 10;
use Data::Dump qw( dump );

use_ok('Text::IQ::EN');

ok( my $iq = Text::IQ::EN->new('t/const.txt'), "new IQ" );
diag sprintf( "Number of words: %d\n",     $iq->num_words );
diag sprintf( "Avg word length: %d\n",     $iq->word_length );
diag sprintf( "Number of sentences: %d\n", $iq->num_sentences );
diag sprintf( "Avg sentence length: %d\n", $iq->sentence_length );
diag sprintf( "Misspellings: %d\n",        $iq->num_misspellings );
diag( dump $iq->misspelled );

#printf( "Grammar errors: %d\n",      $iq->num_grammar_errors );
