use v6;
use CommonMark;
use Test;

is CommonMark.convert("Hello world!"),
   "<p>Hello world!</p>\n",
   'string converts to HTML'
;
ok CommonMark.version >= 7171,
   'version is at least current'
;
#is $.version-string, '0.28';

done-testing;

# vim: ft=perl6
