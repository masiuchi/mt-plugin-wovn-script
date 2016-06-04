package MT::Plugin::WOVNScript::Callbacks;
use strict;
use warnings;

use MT;

sub build_page {
    my ( $cb, %param ) = @_;

    if ( ( lc $param{file_info}->url ) !~ /\.html?$/ ) {
        return;
    }

    my $plugin = MT->component('wovnscript');
    unless ( $plugin && $plugin->get_config_value('user_token') ) {
        return;
    }

    my $user_token = $plugin->get_config_value('user_token');
    my $script_tag
        = sprintf
        qq{<script src="//j.wovn.io/1" data-wovnio="key=$user_token" async></script>},
        $user_token;

    if ( ( lc ${ $param{content} } ) =~ /(<\/(?:head|body|html)>)/m ) {
        my $end_tag = quotemeta $1;
        ${ $param{content} } =~ s/($end_tag)/$script_tag\n$1/im;
    }
}

1;

