#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Data::Dump qw( dump );

eval "use Text::Aspell";
plan skip_all => "Text::Aspell unavailable" if $@; 

use_ok('Text::IQ::EN');

ok( my $iq = Text::IQ::EN->new('t/doc/christmas-carol.txt.gz'), "new IQ" );
diag sprintf( "Number of words: %d\n",        $iq->num_words );
diag sprintf( "Avg word length: %0.4f\n",     $iq->avg_word_length );
diag sprintf( "Number of sentences: %d\n",    $iq->num_sentences );
diag sprintf( "Avg sentence length: %0.4f\n", $iq->avg_sentence_length );
diag sprintf( "Misspellings: %d\n",           $iq->num_misspellings );
diag sprintf( "Unique misspellings: %d\n",    $iq->num_uniq_misspellings );
diag sprintf( "Flesch: %0.4f\n",              $iq->flesch );
diag sprintf( "Fog: %0.4f\n",                 $iq->fog );
diag sprintf( "Kincaid: %0.4f\n",             $iq->kincaid );

is( $iq->num_words, 28616, "num_words" );
is( sprintf( "%0.1f", $iq->avg_word_length ), "4.3", "avg_word_length" );
is( $iq->num_sentences, 1886, "num_sentences" );
is( sprintf( "%0.1f", $iq->avg_sentence_length ),
    "15.2", "avg_sentence_length" );
is( $iq->num_misspellings,      548, "num_misspellings" );
is( $iq->num_uniq_misspellings, 369, "num_uniq_misspellings" );
is( sprintf( "%0.1f", $iq->flesch ),  "73.9", "flesch" );
is( sprintf( "%0.1f", $iq->fog ),     "8.8",  "fog" );
is( sprintf( "%0.1f", $iq->kincaid ), "6.7",  "kincaid" );

#diag( dump $iq->misspelled );

#printf( "Grammar errors: %d\n",      $iq->num_grammar_errors );

done_testing();
