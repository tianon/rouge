#!/usr/bin/perl -w
use strict;
use warnings;

package Rouge;

use File::Basename qw(dirname);
use lib dirname(__FILE__);

use Rouge::DataHelper;
use YAML::Any qw();
use File::Temp qw(tempfile);

our $defaultConfig = {
	backupLocation => '/var/lib/rouge',
	rsync => 'rsync',
	git => 'git',
	rsyncDefault => '-aRvh --delete --delete-excluded',
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
			$self->{config}{$key} = $config->{$key} || $self->{config}{$key};
		}
	}
	
	return $self;
}

sub stealOneHost {
	my $self = shift;
	my $host = shift;
	
	my $alias = Rouge::DataHelper::alias($host);
	
	my $backupLocation = $self->{config}{backupLocation} || $defaultConfig->{backupLocation};
	my $currentHostDir = "$backupLocation/$alias";
	
	system 'mkdir', '-p', $currentHostDir and die "error: cannot create $currentHostDir";
	
	unless (-d "$currentHostDir/.git") {
		system $self->{config}{git} || $defaultConfig->{git}, 'init', $currentHostDir and die "error: cannot git init";
	}
	
	my $rsync = Rouge::DataHelper::rsync($host, $self->{config}{rsync}, $self->{config}{rsyncDefault}, $currentHostDir);
	
	my $output = qx{($rsync) 2>&1};
	
	chdir $currentHostDir or die "error: cannot chdir to $currentHostDir: $!";
	
	system $self->{config}{git} || $defaultConfig->{git}, 'add', '-A' and die "error: cannot git add";
	
	my ($tempFh, $tempFile) = tempfile();
	print {$tempFh} $output;
	close $tempFh;
	
	system $self->{config}{git} || $defaultConfig->{git}, 'commit', '-F', $tempFile and warn "warning: cannot git commit";
	
	unlink $tempFile or die "error: cannot unlink temporary commit file $tempFile: $!";
	
	return $self;
}

sub steal {
	my $self = shift;
	my @filters = grep { defined $_ && $_ ne '' } @_;
	
	my @hosts = grep {
		my $ret = 1;
		
		$ret = 0 if @filters; # no filters means match everything
		
		for my $filter (@filters) {
			if (Rouge::DataHelper::hostMatchesFilter($_, $filter)) {
				$ret = 1;
				next;
			}
		}
		
		$ret;
	} @{ $self->{config}{hosts} };
	
	use Data::Dumper;
	for my $host (@hosts) {
		print Dumper($host);
		$self->stealOneHost($host);
	}
	
	return $self;
}

1;
