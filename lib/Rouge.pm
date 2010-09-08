#!/usr/bin/perl -w
use strict;
use warnings;

package Rouge;

use File::Basename qw(dirname);
use lib dirname(__FILE__);

use Rouge::DataHelper;
use YAML::Any ();

our $defaultConfig = {
	backupLocation => '/var/lib/rouge',
	hosts => [],
};

sub new {
	my $class = shift;
	my $self = {
		config => $defaultConfig,
	};
	
	$self = bless($self, $class);
	
	my %functions = @_;
	for my $func (keys %functions) {
		my @args = ($functions{$func});
		
		if ('ARRAY' eq ref $args[0]) {
			@args = @{ $args[0] };
		}
		
		$self->$func(@args);
	}
	
	return $self;
}

sub resetConfig {
	my $self = shift;
	
	$self->{config} = $defaultConfig;
	
	return $self;
}

sub loadConfig {
	my $self = shift;
	my $filename = shift;
	my $resetConfig = shift || 0;
	
	my ($config) = YAML::Any::LoadFile($filename);
	if ($config) {
		$self->resetConfig if $resetConfig;
		
		for my $key (keys %$config) {
			$self->{config}{$key} = $config->{$key};
		}
	}
	
	return $self;
}

sub steal {
	my $self = shift;
	my @filters = grep { defined $_ && $_ ne '' } @_;
	
	my @hosts = grep {
		return 1 unless @filters; # no filters means match everything
		
		for my $filter (@filters) {
			return 1 if Rouge::DataHelper::hostMatchesFilter($_, $filter);
		}
		
		return 0;
	} @{ $self->{config}{hosts} };
	
	# TODO backup @hosts
	use Data::Dumper;
	print Dumper(@hosts);
	
	return $self;
}

1;
