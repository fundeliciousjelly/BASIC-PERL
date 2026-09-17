use warnings;
use strict;

use Lexer;

if (scalar @ARGV != 2 && scalar @ARGV != 3) 
{
	die 'Usage: Jelly <Lang> <Options> [<Files.bas>]';
}

if (uc $ARGV[0] eq 'BASIC')
{
	if (uc $ARGV[1] eq 'COMPILE')
	{
		
	}
	elsif (uc $ARGV[1] eq 'INTERPRET')
	{
		print "Jelly BASIC version 0.1.0\n\n";
		while (1)
		{
			print "READY.\n\n";
			my $buffer = "";
			while (my $line = readline STDIN)
			{
				chomp $line;
				last if uc $line eq 'RUN';
				die if uc $line eq 'EXIT';
				$buffer = $buffer . $line . "\n";
			}
			my $lexer = Lexer::Tokenize $buffer;
			print "done";
			print Lexer::Stringify $lexer;
		}
	}
}
