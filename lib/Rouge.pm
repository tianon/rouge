#!/usr/bin/perl -w
use strict;
use warnings;

package Rouge;

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
	
	return bless($self, $class);
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

1;
