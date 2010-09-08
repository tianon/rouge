#!/usr/bin/perl -w
use strict;
use warnings;

use File::Basename qw(dirname);
use lib dirname(__FILE__) . '/lib';

use Getopt::Long;
use Rouge;

sub usage {
	print {*STDERR} "usage: $0 [options] [filters...]\n";
	print {*STDERR} "   ie: $0 susan          # for all hosts with given hostname/alias\n";
	print {*STDERR} "       $0 tianon\@susan   # for all hosts with given user\@host combo\n";
	print {*STDERR} "       $0 tianon@        # for all hosts with given username\n";
	print {*STDERR} "       $0 tianon@ susan  # for all hosts matching any given filter\n";
	print {*STDERR} "\n";
	print {*STDERR} "options:\n";
	print {*STDERR} "  -c, --config=path\n";
	print {*STDERR} "    specify explicit path to alternate config.yml\n";
	print {*STDERR} "\n";
	exit 1;
}

my $config = dirname(__FILE__) . '/config.yml';
GetOptions(
	'c|config=s' => \$config,
) or usage;

my $rouge = Rouge->new(
	loadConfig => [ $config, 1 ],
);

Rouge::steal(@ARGV);
