package Lexer;

use warnings;
use strict;
use Data::Dumper;

use TokenType;

my $token = undef;
my $buffer;
my @string;
my $position = 0;
my $column = 1;

sub Tokenize
{
	$buffer = shift;
	@string = split //, $buffer;
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
	return HasEnded() ? "\0" : $string[$position];
}

sub NextCharacter
{
	my $current = PeekCharacter;
	if ($current eq "\n")
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
	
	return $string[$position++];
}

sub SkipWhitespace
{
	while ($string[$position] =~ /\s+/)
	{
		NextCharacter;
	}
}

sub GetToken
{
	return ["", $TokenType::EOF, $column] if HasEnded();
	
	SkipWhitespace;
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
	my $current = substr $buffer, $Currentposition, $position - $Currentposition;
	return [$current,
		$TokenType::keywords{uc $current},
		$Currentcolumn];
}

sub GetNumber
{
	my ($Currentposition, $Currentcolumn) = @_;
	while (PeekCharacter =~ /\d+/)
	{
		NextCharacter;
	}
	my $current = substr $buffer, $Currentposition, $position - $Currentposition;
	return [$current, $TokenType::NUMBER, $Currentcolumn];
}

sub GetString
{
	my ($Currentposition, $Currentcolumn) = @_;
	do { NextCharacter; } while (PeekCharacter() ne '"');
	my $current = substr $buffer, $Currentposition + 1, $position - $Currentposition - 1;
	NextCharacter;
	return [$current, $TokenType::STRING, $Currentcolumn];
}

sub GetSymbol
{
	my $Currentcolumn = shift;
	my $current = NextCharacter;
	return [$current, $TokenType::symbols->{$current}, $Currentcolumn];
}

sub Stringify
{
	my $invocant = shift;
	my $current = "";
	foreach my $tok ($invocant->@*)
	{
		if ($tok->[0] ne $TokenType::EOF)
		{
			$current = $current . "value: $tok->[0], type: $tok->[1], column: $tok->[2]\n";
		}
	}
	return $current;
}

1;
