#!/usr/bin/env perl

use warnings;
use strict;
use diagnostics;
use utf8;

use autodie;
use feature qw(say switch);

use File::Find;
use Path::Class;
use File::Copy::Recursive qw/rcopy/;

binmode STDIN, ":encoding(UTF-8)";
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";

my $BACKUP_DIR = ".eater";
my $dir = shift;
die "Usage: ./comment_eater target_dir" unless $dir;

dir($BACKUP_DIR)->rmtree if -d $BACKUP_DIR;
mkdir $BACKUP_DIR;
rcopy($dir, $BACKUP_DIR);

find(\&eat_comment, $dir);

sub eat_comment {
    if (-f $_) {
        open my $in, "<:encoding(utf-8)", $_;
        my @lines = <$in>;
        close $in;
        open my $out, ">:utf8", $_;
        print $out grep { !is_comment_line($_) } @lines;
        close $out;
    }
}

sub is_comment_line {
    my $line = shift;
    return 1 if $line =~ /^\s+\*\s+(作成|変更履歴)\s+:\s+\[日付\]\s+\d{4}\/\d{2}\/\d{2}\s+\[氏名\]/;
    return 1 if $line =~ /^\s+\/\/\s+\d{4}\/\d{2}\/\d{2}/;
    return 0;
}

