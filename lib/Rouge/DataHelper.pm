#!/usr/bin/perl -w
use strict;
use warnings;

package Rouge::DataHelper;

sub hostMatchesFilter {
	my $host = shift || {};
	my $filter = shift;
	
	return 0 unless $filter;
	
	my $hostname = hostname($host);
	my $username = username($host);
	my $userAtHost = userAtHost($host);
	my $alias = alias($host);
	
	return (
		$filter eq $hostname
		|| $filter eq $username . '@'
		|| $filter eq $userAtHost
		|| $filter eq $alias
	);
}

sub hostname {
	my $host = shift || {};
	
	return $host->{hostname} || 'localhost';
}

sub username {
	my $host = shift || {};
	
	return $host->{username} || getlogin;
}

sub userAtHost {
	my $host = shift || {};
	
	my $username = username($host);
	my $hostname = hostname($host);
	
	return $username . '@' . $hostname;
}

sub alias {
	my $host = shift || {};
	
	return $host->{alias} || userAtHost($host);
}

sub rsync {
	my $host = shift || {};
	my $rsync = shift || $Rouge::defaultConfig->{rsync};
	my $rsyncDefault = shift || $Rouge::defaultConfig->{rsyncDefault};
	my $backupLocation = shift || $Rouge::defaultConfig->{backupLocation} . '/' . alias($host);
	
	my $rsyncExtra = $host->{rsyncExtra} || '';
	
	$rsync .= ' ' . $rsyncDefault . ' ' . $rsyncExtra;
	
	my @include = @{ $host->{include} || [] };
	my @exclude = @{ $host->{exclude} || [] };
	my @exempt = @{ $host->{exempt} || [] };
	
	my $userAtHost = userAtHost($host);
	
	$rsync .= ' ' . join ' ', map { '--include="' . $_ . '"' } @exempt;
	
	$rsync .= ' ' . join ' ', map { '--exclude="' . $_ . '"' } @exclude;
	
	$rsync .= ' ' . join ' ', map { '"' . $userAtHost . ':' . $_ . '"' } @include;
	
	$rsync .= ' "' . $backupLocation . '"';
	
	return $rsync;
}

1;
