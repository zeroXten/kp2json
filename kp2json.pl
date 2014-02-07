#!/usr/bin/env perl -w

use strict;
use File::Basename;
use File::KeePass;
use Term::ReadKey;
use JSON;

sub usage()
{
  my $name = basename($0);
  print <<EOF;
Usage: $name FILE SEARCH [SEARCH]

Examples

This will search for the title 'linux root user':
  $name password.kdb 'linux root user'

This will search for the username 'root':
  $name password.kdb username:root

A single result will output directly as a hash. Multiple results will be output in an array under the 'entries' key.

EOF
  exit 1;
}

my $file;
my $search = {'group_title !~' => qr/backup/i};

if (@ARGV >= 2) {
  $file = shift @ARGV;
  foreach my $arg (@ARGV) {
    if ($arg =~ /^([^:]+):(.+)$/) {
      $search->{$1} = $2;
    }
    else {
      $search->{'title'} = $arg;
    }
  }
} else {
  usage;
}

ReadMode('noecho');
print STDERR "Password: ";
my $password = ReadLine(0);
ReadMode(0);
print STDERR "\n";
chomp($password);

my $k = File::KeePass->new;
if (! eval { $k->load_db($file, $password) }) {
  die "Couldn't load the file $file: $@";
}

$k->unlock;
my @e = $k->find_entries($search);
$k->lock;

# Scrub the entries a bit
foreach my $entry (@e) {
  delete $entry->{'icon'};
  delete $entry->{'id'};
}

my $entries = { 'entries' => [] };

if (@e == 0) {
  print STDERR "No entries found\n";
  exit 2;
} elsif (@e == 1) {
  $entries = $e[0];
} else {
  foreach my $entry (@e) {
    push(@{$entries->{'entries'}}, $entry);
  }
}

print to_json($entries)."\n";

exit 0;
