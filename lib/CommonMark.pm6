use v6;

=begin pod

=head1 CommonMark

Interface to the L<libcmark> CommonMark parser

=head1 Synopsis

    use CommonMark;

    say CommonMark.convert("Hello, world!");
    # "<p>Hello, world!</p>"

    say CommonMark.version-string;
    # 0.28.3

=head1 Documentation

Load and use the CommonMark C library.

=end pod

unit class CommonMark;

use NativeCall;

constant CMARK_OPT_DEFAULT = 0;
constant CMARK_OPT_SOURCEPOS = 1 +< 1;
constant CMARK_OPT_HARDBREAKS = 1 +< 2;
constant CMARK_OPT_SAFE = 1 +< 3;
constant CMARK_OPT_NOBREAKS = 1 +< 4;
constant CMARK_OPT_NORMALIZE = 1 +< 8; # Legacy
constant CMARK_OPT_VALIDATE_UTF8 = 1 +< 9;
constant CMARK_OPT_SMART = 1 +< 10;

my sub cmark_markdown_to_html(Str $text, size_t $len, int16 $options) returns Str is native('cmark') { * }
my sub cmark_version() returns int16 is native('cmark') { * }
my sub cmark_version_string() returns Str is native('cmark') { * }

method convert( Str $text, int16 $options = CMARK_OPT_DEFAULT ) {
	my $bytes = $text.encode('UTF-8').bytes;
	return cmark_markdown_to_html($text, $bytes, $options);
}

method version() {
	return cmark_version();
}

method version-string() {
	return cmark_version_string();
}

# vim: ft=perl6
