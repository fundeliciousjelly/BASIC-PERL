package Lexer;

use warnings;
use strict;

use TokenType;

my $token = undef;
my $buffer;
my $position = 0;
my $column = 1;

sub Tokenize
{
	$buffer = shift;
	while (1)
	{
		my $tok = GetToken();
		push $token->@*, $tok;
		last if $tok->[1] eq $TokenType::EOF;
	}
	return $token;
}

sub HasEnded
{
	return $position >= length $buffer;
}

sub PeekCharacter
{
	return HasEnded() ? "\0" : substr $buffer, $position - 1, 1;
}

sub NextCharacter
{
	my $current = PeekCharacter;
	if ($current =~ /\s/)
	{
		push $token->@*, 
			["", 
			$TokenType::END_OF_LINE,
			$column];
		$column = 0;
	}
	elsif (HasEnded())
	{
		return "\0";
	}
	else
	{
		$column++;
	}

	return substr $buffer, $position++ - 1, 1;
}

sub SkipWhitespace
{
	while (substr $buffer, $position - 1, 1 =~ /\s+/)
	{
		NextCharacter;
	}
}

sub GetToken
{
	return ["", $TokenType::EOF, $column] if HasEnded();

	my $current = PeekCharacter;
	return GetKeywordOrIdentifier($position, $column) if $current =~ /[A-Za-z]+/;
	return GetNumber($position, $column) if $current =~ /\d+/;
	return GetSymbol($column) if $current eq grep $current, keys %TokenType::symbols;
	return GetString($position, $column) if $current eq '"';

	NextCharacter;	
	return ["", $TokenType::UNKNOWN, $column];
}

sub GetKeywordOrIdentifier
{
	my ($Currentposition, $Currentcolumn) = @_;
	while (PeekCharacter =~ /\w+/)
	{
		NextCharacter;
	}
	my $current = substr $buffer, $Currentposition, $Currentposition - $Currentposition;
	return [$current,
		$TokenType::keywords{uc $buffer},
		$column];
}

sub GetNumber
{
	my ($Currentposition, $Currentcolumn) = @_;
	while (PeekCharacter =~ /\d+/)
	{
		NextCharacter;
	}
	my $current = substr $buffer, $Currentposition, $position - $Currentposition;
	return [$current, $TokenType::NUMBER, $column];
}

sub GetString
{
	my ($Currentposition, $Currentcolumn) = @_;
	do { NextCharacter; } while (PeekCharacter() ne '"');
	my $current = substr $buffer, $position + 1, $Currentposition - $position;
	NextCharacter;
	return [$current, $TokenType::STRING, $column];
}

sub GetSymbol
{
	my $column = shift;
	my $current = NextCharacter;
	return [$current, $TokenType::symbols->{$current}, $column];
}

sub Stringify
{
	my $invocant = shift;
	my $current = "";
	foreach my $tok ($invocant->@*)
	{
		if ($tok->[0] ne $TokenType::EOF)
		{
			$current = $current . "value: $tok->[1], type: $tok->[0], location: $tok->[2]\n";
		}
	}
	return $current;
}

1;
