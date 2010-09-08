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

sub reset_config {
	my $self = shift;
	
	$self->{config} = $defaultConfig;
	
	return $self;
}

sub load_config {
	my $self = shift;
	my $filename = shift;
	my $resetConfig = shift || 0;
	
	my ($config) = YAML::Any::LoadFile($filename);
	if ($config) {
		$self->reset_config if $resetConfig;
		
		for my $key (keys %$config) {
			$self->{config}{$key} = $config->{$key};
		}
	}
	
	return $self;
}

sub perform_backup {
	my $self = shift;
	my @filters = @_;
	
	my @hosts = grep {
		return 1 unless @filters; # no filters means match everything
		
		my $hostname = Rouge::DataHelper::hostname($_);
		my $username = Rouge::DataHelper::username($_);
		my $userAtHost = Rouge::DataHelper::userAtHost($_);
		my $alias = Rouge::DataHelper::alias($_);
		
		for my $filter (@filters) {
			if (
				$filter eq $hostname
				|| $filter eq $username
				|| $filter eq $userAtHost
				|| $filter eq $alias
			) {
				return 1;
			}
		}
		
		return 0;
	} @{ $self->{config}{hosts} };
	
	return $self;
}

1;
