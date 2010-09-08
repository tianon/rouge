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

1;
