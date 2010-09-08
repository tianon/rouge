#!/usr/bin/perl -w
use strict;
use warnings;

package Rouge::DataHelper;

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
