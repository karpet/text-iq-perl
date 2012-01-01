#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 10;
use Data::Dump qw( dump );

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

#diag( dump $iq->misspelled );

#printf( "Grammar errors: %d\n",      $iq->num_grammar_errors );
