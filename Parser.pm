package Parser;

use warnings;
use strict;

use Coefficient;
use StringLiteral;

use TokenType;

our @error = ();

my $token = [];
my $position = 0;
my $previousLineNumber = -1;

sub Term
{
	my $Left = Factor;
	return unless defined $Left;
	my $Current = GetToken;
	switch($Current[1])
	{
		case $TokenType::ASTERISK
		{
			NextToken;
			my $Right = Term;
			my $LeftObject = ref $Left;
			my $RightObject = ref $Right;
			if (($LeftObject eq 'StringLiteral' && $RightObject eq 'Coefficient') or
				($LeftObject  eq 'Coefficient' && $RightObject eq 'StringLiteral'))
			{
				push @error, "in the line of $previousLineNumber, string doesn't accept operator '*' with coefficient in column $Current[2]";
			}
			return Multiplication->New($Left, $Right);
		}
		case $TokenType::SLASH
		{
			NextToken;
			my $Right = Term;
			my $LeftObject = ref $Left;
			my $RightObject = ref $Right;
			if (($LeftObject eq 'StringLiteral' && $RightObject eq 'Coefficient') or
				($LeftObject  eq 'Coefficient' && $RightObject eq 'StringLiteral'))
			{
				push @error, "in the line of $previousLineNumber, string doesn't accept operator '/' with coefficient in column $Current[2]";
			}
			if ($RightObject eq 'Coefficient')
			{
				my $value = Coefficient->New($Right->{value});
				if ($value->{value} == 0.0)
				{
					 my $CurrentToken = GetToken;
					 push @error, "in the line of $previousLineNumber, division by zero is detected in column $Current[2]";
				}
			}
			return Divistion->New($Left, $Right);
		}
	}
	return $Left;
}

sub Factor
{
	my $CurrentToken = GetToken;
	NextToken;
	return Coefficient->New($CurrentToken[0] + 0) if $CurrentToken[1] eq $TokenType::NUMBER;
	return String_Literal->New($CurrentToken[0] .= '') if $CurrentToken[1] eq $TokenType::STRING;
	return;
}

sub HasEnded
{
	return $token->[$position][1] == $TokenType::END_OF_FILE;
}

sub GetToken
{
	return $token->[$position];
}

sub NextToken
{
	return if HasEnded();
	$position++;
}
