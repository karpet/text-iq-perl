#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 11;
use Data::Dump qw( dump );

use_ok('Text::IQ::EN');

ok( my $iq = Text::IQ::EN->new('t/doc/bible.txt.gz'), "new IQ" );
diag sprintf( "Number of words: %d\n",        $iq->num_words );
diag sprintf( "Avg word length: %0.4f\n",     $iq->avg_word_length );
diag sprintf( "Number of sentences: %d\n",    $iq->num_sentences );
diag sprintf( "Avg sentence length: %0.4f\n", $iq->avg_sentence_length );
diag sprintf( "Misspellings: %d\n",           $iq->num_misspellings );
diag sprintf( "Unique misspellings: %d\n",    $iq->num_uniq_misspellings );
diag sprintf( "Flesch: %0.4f\n",              $iq->flesch );
diag sprintf( "Fog: %0.4f\n",                 $iq->fog );
diag sprintf( "Kincaid: %0.4f\n",             $iq->kincaid );

is( $iq->num_words, 1104223, "num_words" );
is( sprintf( "%0.1f", $iq->avg_word_length ), "4.0", "avg_word_length" );
is( $iq->num_sentences, 48554, "num_sentences" );
is( sprintf( "%0.1f", $iq->avg_sentence_length ),
    "22.7", "avg_sentence_length" );
is( $iq->num_misspellings,      88255, "num_misspellings" );
is( $iq->num_uniq_misspellings, 8455,  "num_uniq_misspellings" );
is( sprintf( "%0.1f", $iq->flesch ),  "71.0", "flesch" );
is( sprintf( "%0.1f", $iq->fog ),     "11.9", "fog" );
is( sprintf( "%0.1f", $iq->kincaid ), "9.0",  "kincaid" );

#diag( dump $iq->misspelled );

#printf( "Grammar errors: %d\n",      $iq->num_grammar_errors );
