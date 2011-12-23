package Text::IQ::EN;
use strict;
use warnings;
use base 'Text::IQ';

sub num_misspellings {
    my $self = shift;
    return $self->{_num_misspelled} if defined $self->{_num_misspelled};
    my $checker = Search::Tools::SpellCheck->new( lang => 'en_US', );
    my $aspell = $checker->aspell;
    my @errs;
    my $n = 0;
    while ( my $t = $self->{_tokens}->next ) {
        if ( $t->is_match ) {
            if ( !$aspell->check("$t") ) {
                push @errs, "$t";
                $n++;
            }
        }
    }
    $self->{_misspelled}     = \@errs;
    $self->{_num_misspelled} = $n;
    $self->{_tokens}->reset;
    return $self->{_num_misspelled};
}

sub misspelled {
    my $self = shift;
    return $self->{_misspelled} if defined $self->{_misspelled};
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
