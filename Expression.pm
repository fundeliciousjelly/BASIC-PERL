package Expression;

use warnings;
use strict;

use Switch;

sub New
{
	my $invocant = shift;
	my %blessed_argument;
	my $packages = (caller)[0];
	
	switch ($packages)
	{
		case 'Coefficient' { %blessed_argument->{value} = shift; }
		case 'StringLiteral' { %blessed_argument->{value} = shift; }
	}
	return bless %blessed_argument, $packages;
}

1;
