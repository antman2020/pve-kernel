#!/usr/bin/perl -w

use strict;

my $dir = shift;

die "no directory to scan" if !$dir;

die "no such directory" if ! -d $dir;

warn "\n\nNOTE: strange directory name: $dir\n\n" if $dir !~ m|^(.*/)?(\d+.\d+.\d+\-\d+\-pve)(/+)?$|;

my $apiver = $2;

open(TMP, "find '$dir' -name '*.ko'|");
while (defined(my $fn = <TMP>)) {
    chomp $fn;
    my $relfn = $fn;
    $relfn =~ s|^$dir/*||;

    my $cmd = "/sbin/modinfo -F firmware '$fn'";
    open(MOD, "$cmd|");
    while (defined(my $fw = <MOD>)) {
	chomp $fw;
	print "$fw $relfn\n";
    }
    close(MOD);

}
close TMP;

exit 0;
