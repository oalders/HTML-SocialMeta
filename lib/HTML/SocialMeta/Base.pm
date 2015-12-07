package HTML::SocialMeta::Base;
use Moose;
use namespace::autoclean;
use Carp;
our $VERSION = '0.2';

# A list of fields which the cards may possibly use
has [
    qw(card_type card type name url)
  ] => ( 
    isa => 'Str', 
    is => 'rw', 
    lazy => 1, 
    default => q{}, 
  );

has [
    qw(site site_name title description image creator app_country app_name_store app_id_store app_url_store app_name_play app_id_play app_url_play player player_height player_width)
  ] => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => q{},
  );


sub create {
    my ( $self, $card_type ) = @_;

    $card_type ||= $self->card_type;

    my %card_options = $self->card_options;

    if ( my $option = $card_options{$card_type} ) {

        return $self->$option;
    }

    return $self->_no_card_type($card_type);
}

sub build_meta_tags {
    my ( $self, $field ) = @_;

    my @meta_tags;

    push @meta_tags, $self->item_type
        if $self->meta_attribute eq q{itemprop};

    foreach my $field ( $self->required_fields($field) ) {
        # check the field has a value set
        $self->_validate_field_value($field);

        push @meta_tags, $self->_generate_meta_tag($field);
    }

    return join "\n", @meta_tags;
}

sub required_fields {
    my ( $self, $field ) = @_;

    my %required_fields = $self->build_fields;

    if ( my @options = @{ $required_fields{$field} } ) {

        return @options;
    }
}

sub _validate_field_value {
    my ( $self, $field ) = @_;

    # look to see we have the fields atrribute set
    croak q{you have not set this field value } . $field
      if !$self->$field;

    return;
}

sub _generate_meta_tag {
    my ( $self, $field ) = @_;

    my @tags = ();

    if ( $field =~ m{^player}xms ) {
        for ( @{ $self->_convert_field($field) } ) {
            push @tags, $self->_build_field( $field, $_ );
        }
        return @tags;
    }

    return $self->_build_field($field) if $field !~ m{^app}xms;

    for ( @{ $self->_convert_field($field) } ) {
        push @tags, $self->_build_field( $field, $_ );
    }

    return @tags;
}

sub _build_field {
    my ( $self, $field, $field_type ) = @_;

    $field_type = $field_type ? $field_type : $field;

    return
        q{<meta }
      . $self->meta_attribute . q{="}
      . $self->meta_namespace . q{:}
      . $field_type
      . q{" content="}
      . $self->$field . q{"/>};
}

sub _convert_field {
    my ( $self, $field ) = @_;

    $field =~ tr/_/:/;

    return $self->_provider_convert($field);
}

sub meta_option {
    my ( $self, $card_type ) = @_;

    # get the current providers card options
    my %cards = $self->card_options;

    if ( my $option = $cards{$card_type} ) {

        # remove create_ and we have the card type
        $option =~ s{^create_}{}xms;
        return $option;
    }
}

sub _no_card_type {
    my ( $self, $card_type ) = @_;
    return croak
q{this card type does not exist try one of these summary, featured_image, app, player};
}

#
# The End
#
__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

HTML::SocialMeta::Base
 
=head1 DESCRIPTION

Base class for the different meta classes.

builds and returns the Meta Tags

=cut

=head1 VERSION

Version 0.2

=cut

=head1 SYNOPSIS

=head1 SUBROUTINES/METHODS

=head2 build_meta_tags 

This builds the meta tags for Twitter and OpenGraph

It takes an array of fields, which loops through firstly checking 
that we have a value set and then actually building the specific tag
for that field.

=cut

=head2 required_fields

returns an array of the fields that are required to build a specific card

=cut

=head1 AUTHOR

Robert Acock <ThisUsedToBeAnEmail@gmail.com>

With special thanks to:
Robert Haliday <robh@cpan.org>

=head1 TODO
 
    * Improve tests
    * Add support for more social Card Types / Meta Providers
 
=head1 BUGS AND LIMITATIONS
 
Most probably. Please report any bugs at http://rt.cpan.org/.

=head1 INCOMPATIBILITIES

=head1 DEPENDENCIES

Moose - Version 2.0604
Namespace::Autoclean - Verstion 0.15
List::MoreUtils - Version 0.413 

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DIAGNOSTICS 

=head1 LICENSE AND COPYRIGHT
 
Copyright 2015 Robert Acock.
 
This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:
 
L<http://www.perlfoundation.org/artistic_license_2_0>
 
Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.
 
If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.
 
This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.
 
This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.
 
Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

