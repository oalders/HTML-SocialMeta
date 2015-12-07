package HTML::SocialMeta::OpenGraph;
use Moose;
use namespace::autoclean;
use Carp;

our $VERSION = '0.2';

extends 'HTML::SocialMeta::Base';

# Provider Specific Fields
has 'meta_attribute' =>
  ( isa => 'Str', is => 'ro', required => 1, default => 'property' );
has 'meta_namespace' =>
  ( isa => 'Str', is => 'ro', required => 1, default => 'og' );

sub card_options {
    return (
        summary        => q(create_thumbnail),
        featured_image => q(create_article),
        player         => q(create_video),
        app            => q(create_product),
    );
}

sub build_fields {
    return (
        thumbnail => [qw(type title description url image site_name)],
        article   => [qw(type title description url image site_name)],
        video     => [
            qw(type site_name url title image description player player_width player_height)
        ],
        product   => [qw(type title image description url)]
    );
}

sub create_thumbnail {
    my ($self) = @_;

    $self->type('thumbnail');

    return $self->build_meta_tags( $self->type );
}

sub create_article {
    my ($self) = @_;

    $self->type('article');

    return $self->build_meta_tags( $self->type );
}

sub create_video {
    my ($self) = @_;

    $self->type('video');

    return $self->build_meta_tags( $self->type );
}

sub create_product {
    my ($self) = @_;

    $self->type('product');

    return $self->build_meta_tags( $self->type );
}

sub _provider_convert {
    my ( $self, $field ) = @_;

    $field =~ tr/_/:/;

    my @app_fields;
    
    if ( $field =~ s{^player}{video}xms ) {

        if ( $field =~ m{^video$}xms ) {

            push @app_fields, $field . ':url';
            push @app_fields, $field . ':secure_url';

        }
        else {

            push @app_fields, $field;

        }
    }

    return \@app_fields;
}


#
# The End
#
__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

HTML::SocialMeta::OpenGraph

=head1 VERSION

Version 0.2

=cut

=head1 DESCRIPTION

Base class for creating OpenGraph meta data

=head1 METHODS

=cut

=head1 SYNOPSIS

=head1 SUBROUTINES/METHODS

=head2 create 

current card options

    * summary
    * featured_image

=cut

=head2 create_thumbnail_card 

Required Fields

    * type
    * title
    * description
    * url
    * image 
    * site_name 

=cut

=head2 create_article_card

Required Fields

    * type
    * title
    * description
    * url
    * image 
    * site_name 

=cut

=head1 AUTHOR

Robert Acock <ThisUsedToBeAnEmail@gmail.com>

With special thanks to:
Robert Haliday <robh@cpan.org>

=head1 TODO
 
    * Add support for more social Card Types / Meta Providers
 
=head1 BUGS AND LIMITATIONS
 
Most probably. Please report any bugs at http://rt.cpan.org/.

=head1 INCOMPATIBILITIES

=head1 DEPENDENCIES

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



