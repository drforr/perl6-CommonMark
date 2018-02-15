use v6;

=begin pod

=head1 CommonMark

Interface to the L<libcmark> CommonMark parser

=head1 Synopsis

    use CommonMark;

    say CommonMark.to-html("Hello, world!");
    # "<p>Hello, world!</p>"

    say CommonMark.version-string;
    # 0.28.3

=head1 Documentation

CommonMark is Markdown with a proper spec - It should render most Markdown
files the same; it nails down some edge cases, and specifies byte encodings.

You'll want to call C<.to-html($text)> to convert markdown to HTML. The
library itself also supports XML, LaTeX, and nroff/troff formats, but I haven't
seen where it's tested. Check out the Perl 6 source for more details there.

=head2 METHODS

=item to-html( $common-mark )

Return HTML from CommonMark format. This is likely the only method you'll use.
There's a lower-level interface that'll let you interrogate the library at the
individual node level, look at the source for more inspiration.

=item version()

Returns a 32-bit int containing the version number.

From the documetation:

 * Bits 16-23 contain the major version.
 * Bits 8-15 contain the minor version.
 * Bits 0-7 contain the patchlevel.

=item version-string()

Returns the library version in text form.

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

#`( The original C interface
char *cmark_markdown_to_html(const char *text, size_t len, int options);
int32 cmark_version(void);
const char *cmark_version_string(void);
)

sub cmark_markdown_to_html(Str $text, size_t $len, int16 $options)
    returns Str
    is native('cmark') { * }
sub cmark_version()
    returns int16
    is native('cmark') { * }
sub cmark_version_string()
    returns Str
    is native('cmark') { * }

#`(
cmark_node *cmark_node_new(cmark_node_type type);
cmark_node *cmark_node_new_with_mem(cmark_node_type type, cmark_mem *mem);
void cmark_node_free(cmark_node *node);
cmark_node *cmark_node_next(cmark_node *node);
cmark_node *cmark_node_previous(cmark_node *node);
cmark_node *cmark_node_parent(cmark_node *node);
cmark_node *cmark_node_first_child(cmark_node *node);
cmark_node *cmark_node_last_child(cmark_node *node);
)

#`(
void *cmark_node_get_user_data(cmark_node *node);
int cmark_node_set_user_data(cmark_node *node, void *user_data);
cmark_node_type cmark_node_get_type(cmark_node *node);
const char *cmark_node_get_type_string(cmark_node *node);
const char *cmark_node_get_literal(cmark_node *node);
int cmark_node_set_literal(cmark_node *node, const char *content);
int cmark_node_set_heading_level(cmark_node *node, int level);
cmark_list_type cmark_node_get_list_type(cmark_node *node);
int cmark_node_set_list_type(cmark_node *node, cmark_list_type type);
cmark_delim_type cmark_node_get_list_delim(cmark_node *node);
int cmark_node_set_list_delim(cmark_node *node, cmark_delim_type delim);
int cmark_node_get_list_start(cmark_node *node);
int cmark_node_set_list_start(cmark_node *node, int start);
int cmark_node_get_list_tight(cmark_node *node);
int cmark_node_set_list_tight(cmark_node *node, int tight);
const char *cmark_node_get_fence_info(cmark_node *node);
int cmark_node_set_fence_info(cmark_node *node, const char *info);
const char *cmark_node_get_url(cmark_node *node);
int cmark_node_set_url(cmark_node *node, const char *url);
const char *cmark_node_get_title(cmark_node *node);
int cmark_node_set_title(cmark_node *node, const char *title);
const char *cmark_node_get_on_enter(cmark_node *node);
int cmark_node_set_on_enter(cmark_node *node, const char *on_enter);
const char *cmark_node_get_on_exit(cmark_node *node);
int cmark_node_set_on_exit(cmark_node *node, const char *on_exit);
int cmark_node_get_start_line(cmark_node *node);
int cmark_node_get_start_column(cmark_node *node);
int cmark_node_get_end_line(cmark_node *node);
int cmark_node_get_end_column(cmark_node *node);
)

#`(
void cmark_node_unlink(cmark_node *node);
int cmark_node_insert_before(cmark_node *node, cmark_node *sibling);
int cmark_node_insert_after(cmark_node *node, cmark_node *sibling);
int cmark_node_replace(cmark_node *oldnode, cmark_node *newnode);
int cmark_node_prepend_child(cmark_node *node, cmark_node *child);
int cmark_node_append_child(cmark_node *node, cmark_node *child);
void cmark_consolidate_text_nodes(cmark_node *root);
)

# type is an enum in the interface.
class CMarkNode is repr('CPointer') {
	sub cmark_node_new( int16 )
	    returns CMarkNode
	    is native('cmark') { * }
	sub cmark_node_free( CMarkNode )
	    is native('cmark') { * }
	sub cmark_node_next( CMarkNode )
	    returns CMarkNode
	    is native('cmark') { * }
	sub cmark_node_previous( CMarkNode )
	    returns CMarkNode
	    is native('cmark') { * }
	sub cmark_node_parent( CMarkNode )
	    returns CMarkNode
	    is native('cmark') { * }
	sub cmark_node_first_child( CMarkNode )
	    returns CMarkNode
	    is native('cmark') { * }
	sub cmark_node_last_child( CMarkNode )
	    returns CMarkNode
	    is native('cmark') { * }

	sub cmark_node_get_user_data( CMarkNode )
	    returns Pointer
	    is native('cmark') { * }
	sub cmark_node_set_user_data( CMarkNode, Pointer )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_get_type( CMarkNode )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_get_type_string( CMarkNode )
	    returns Str
	    is native('cmark') { * }
	sub cmark_node_get_literal( CMarkNode )
	    returns Str
	    is native('cmark') { * }
	sub cmark_node_set_literal( CMarkNode, Str )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_set_heading_level( CMarkNode, int16 )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_get_list_type( CMarkNode )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_set_list_type( CMarkNode, int16 )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_get_list_delim( CMarkNode )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_set_list_delim( CMarkNode, int16 )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_get_list_start( CMarkNode )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_set_list_start( CMarkNode, int16 )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_get_list_tight( CMarkNode )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_set_list_tight( CMarkNode, int16 )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_get_fence_info( CMarkNode )
	    returns Str
	    is native('cmark') { * }
	sub cmark_node_set_fence_info( CMarkNode, Str )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_get_url( CMarkNode )
	    returns Str
	    is native('cmark') { * }
	sub cmark_node_set_url( CMarkNode, Str )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_get_title( CMarkNode )
	    returns Str
	    is native('cmark') { * }
	sub cmark_node_set_title( CMarkNode, Str )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_get_on_enter( CMarkNode )
	    returns Str
	    is native('cmark') { * }
	sub cmark_node_set_on_enter( CMarkNode, Str )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_get_on_exit( CMarkNode )
	    returns Str
	    is native('cmark') { * }
	sub cmark_node_set_on_exit( CMarkNode, Str )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_get_start_line( CMarkNode )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_get_start_column( CMarkNode )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_get_end_line( CMarkNode )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_get_end_column( CMarkNode )
	    returns int16
	    is native('cmark') { * }

	sub cmark_node_unlink( CMarkNode )
	    is native('cmark') { * }
	sub cmark_node_insert_before( CMarkNode, CMarkNode )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_insert_after( CMarkNode, CMarkNode )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_replace( CMarkNode, CMarkNode )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_prepend_child( CMarkNode, CMarkNode )
	    returns int16
	    is native('cmark') { * }
	sub cmark_node_append_child( CMarkNode, CMarkNode )
	    returns int16
	    is native('cmark') { * }
	sub cmark_consolidate_text_nodes( CMarkNode )
	    is native('cmark') { * }

	method new( :$type ) {
		cmark_node_new( $type );
	}
	method next {
		cmark_node_next( self );
	}
	method previous {
		cmark_node_previous( self );
	}
	method parent {
		cmark_node_parent( self );
	}
	method first-child {
		cmark_node_first_child( self );
	}
	method last-child {
		cmark_node_last_child( self );
	}

	multi method user-data {
		cmark_node_get_user_data( self );
	}
	multi method user-data( Pointer $ptr ) {
		cmark_node_set_user_data( self, $ptr );
	}

	method type {
		cmark_node_get_type( self );
	}

	method type-string {
		cmark_node_get_type_string( self );
	}

	multi method literal {
		cmark_node_get_literal( self );
	}
	multi method literal( Str $str ) returns int16 {
		cmark_node_set_literal( self, $str );
	}

	method heading-level( int16 $level ) {
		cmark_node_set_heading_level( self, $level );
	}

	multi method list-type {
		cmark_node_get_list_type( self );
	}
	multi method list-type( int16 $type ) returns int16 {
		cmark_node_set_list_type( self, $type );
	}

	multi method list-delim {
		cmark_node_get_list_delim( self );
	}
	multi method list-delim( int16 $delim ) returns int16 {
		cmark_node_set_list_delim( self, $delim );
	}

	multi method list-start {
		cmark_node_get_list_start( self );
	}
	multi method list-start( int16 $delim ) returns int16 {
		cmark_node_set_list_start( self, $delim );
	}

	multi method list-tight {
		cmark_node_get_list_tight( self );
	}
	multi method list-tight( int16 $delim ) returns int16 {
		cmark_node_set_list_tight( self, $delim );
	}

	multi method fence-info {
		cmark_node_get_fence_info( self );
	}
	multi method fence-info( Str $info ) returns int16 {
		cmark_node_set_fence_info( self, $info );
	}

	multi method url {
		cmark_node_get_url( self );
	}
	multi method url( Str $url ) returns int16 {
		cmark_node_set_url( self, $url );
	}

	multi method title {
		cmark_node_get_title( self );
	}
	multi method title( Str $title ) returns int16 {
		cmark_node_set_title( self, $title );
	}

	multi method on-enter {
		cmark_node_get_on_enter( self );
	}
	multi method on-enter( Str $enter ) returns int16 {
		cmark_node_set_on_enter( self, $enter );
	}

	multi method on-exit {
		cmark_node_get_on_exit( self );
	}
	multi method on-exit( Str $enter ) returns int16 {
		cmark_node_set_on_exit( self, $enter );
	}

	method start-line {
		cmark_node_get_start_line( self );
	}
	method start-column {
		cmark_node_get_start_column( self );
	}
	method end-line {
		cmark_node_get_end_line( self );
	}
	method end-column {
		cmark_node_get_end_column( self );
	}

	method unlink {
		cmark_node_unlink( self );
	}

	method insert-before( CMarkNode $node ) {
		cmark_node_insert_before( self, $node );
	}

	method insert-after( CMarkNode $node ) {
		cmark_node_insert_after( self, $node );
	}

	method replace( CMarkNode $node ) {
		cmark_node_replace( self, $node );
	}

	method prepend-child( CMarkNode $node ) {
		cmark_node_prepend_child( self, $node );
	}

	method append-child( CMarkNode $node ) {
		cmark_node_append_child( self, $node );
	}

	method consolidate-text-nodes {
		cmark_consolidate_text_nodes( self );
	}

	submethod DESTROY {
		cmark_node_free( self );
	}
}

#`(
cmark_iter *cmark_iter_new(cmark_node *root);
void cmark_iter_free(cmark_iter *iter);
cmark_event_type cmark_iter_next(cmark_iter *iter);
cmark_node *cmark_iter_get_node(cmark_iter *iter);
cmark_event_type cmark_iter_get_event_type(cmark_iter *iter);
cmark_node *cmark_iter_get_root(cmark_iter *iter);
void cmark_iter_reset(cmark_iter *iter, cmark_node *current,
         cmark_event_type event_type);
)

#`(
void cmark_node_unlink(cmark_node *node);
int cmark_node_insert_before(cmark_node *node, cmark_node *sibling);
int cmark_node_insert_after(cmark_node *node, cmark_node *sibling);
int cmark_node_replace(cmark_node *oldnode, cmark_node *newnode);
int cmark_node_prepend_child(cmark_node *node, cmark_node *child);
int cmark_node_append_child(cmark_node *node, cmark_node *child);
void cmark_consolidate_text_nodes(cmark_node *root);
)

class CMarkParser is repr('CPointer') {
	sub cmark_parser_new()
	    returns CMarkParser
	    is native('cmark') { * }
	sub cmark_parser_free( CMarkParser )
	    is native('cmark') { * }
	sub cmark_parser_finish( CMarkParser )
	    returns CMarkNode
	    is native('cmark') { * }
	sub cmark_parser_feed( CMarkParser, Str, size_t )
	    is native('cmark') { * }

	method new {
		cmark_parser_new();
	}
	method feed( Str $buffer ) {
		my $bytes = $buffer.encode('UTF-8').bytes;
		cmark_parser_feed( self, $buffer, $bytes );
	}
	method close {
		cmark_parser_free( self );
	}

	submethod DESTROY {
		cmark_parser_free( self );
	}
}

#`(
cmark_parser *cmark_parser_new(int options);
cmark_parser *cmark_parser_new_with_mem(int options, cmark_mem *mem);
void cmark_parser_free(cmark_parser *parser);
void cmark_parser_feed(cmark_parser *parser, const char *buffer, size_t len);
cmark_node *cmark_parser_finish(cmark_parser *parser);
cmark_node *cmark_parse_document(const char *buffer, size_t len, int options);
cmark_node *cmark_parse_file(FILE *f, int options);
)

#`(
char *cmark_render_xml(cmark_node *root, int options);
char *cmark_render_html(cmark_node *root, int options);
char *cmark_render_man(cmark_node *root, int options, int width);
char *cmark_render_commonmark(cmark_node *root, int options, int width);
char *cmark_render_latex(cmark_node *root, int options, int width);
)

method to-html( Str $text, int16 $options = CMARK_OPT_DEFAULT ) {
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
