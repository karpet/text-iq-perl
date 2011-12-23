#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Text::IQ' );
}

diag( "Testing Text::IQ $Text::IQ::VERSION, Perl $], $^X" );
