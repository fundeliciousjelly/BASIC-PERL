package TokenType;

use warnings;
use strict;

our $EOF = 'END OF FILE';
our $END_OF_LINE = 'END OF LINE';
our $UNKNOWN = 'UNKNOWN';
our $STRING = 'STRING';
our $NUMBER = 'NUMBER';
our ($PLUS, $MINUS, $ASTERISK, $SLASH, $COMMA, $SEMICOLON) =
	("PLUS", "MINUS", "ASTERISK", "SLASH", "COMMA", "SEMICOLON");
our ($LEFT_PARENTHESIS, $RIGHT_PARENTHESIS) =
	("LEFT PARENTHESIS", "RIGHT PARENTHESIS");

our ($PRINT, $END) = ('PRINT', 'END');

our %keywords = 
(
	PRINT => $PRINT,
	END => $END
);

our %symbols =
(
	'+' => $PLUS,
	'-' => $MINUS,
	'*' => $ASTERISK,
	'/' => $SLASH,
	',' => $COMMA,
	';' => $SEMICOLON
);

1;
