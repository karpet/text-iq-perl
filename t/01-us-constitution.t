#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 10;

use_ok('Text::IQ::EN');

ok( my $iq = Text::IQ::EN->new('t/const.txt'), "new IQ" );
