# CommonMark [![Build Status](https://secure.travis-ci.org/drforr/perl6-CommonMark.svg?branch=master)](http://travis-ci.org/drforr/perl6-CommonMark)
CommonMark
=======

Binding to the C CommonMark library.

If you're concerned about compatibility, it's Markdown but with an actual spec. The Markdown "spec" file leaves many edge cases open to interpretation.

Installation
============

Make certain you have libcmark, as this binds to the C library.

* Using zef (a module management tool bundled with Rakudo Star):

```
    zef update && zef install CommonMark
```

## Testing

To run tests:

```
    prove -e perl6
```

## Author

Jeffrey Goff, DrForr on #perl6, https://github.com/drforr/

## License

Artistic License 2.0
