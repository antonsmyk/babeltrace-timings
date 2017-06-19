#!/usr/bin/perl -w

# The babeltrace-timings suite
# Copyright 2017 Itiviti AB, Anton Smyk <Anton.Smyk@itiviti.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

use strict;

use constant MILLION => 1000000.0;
use constant MILLIARD => 1000000000.0;

my $ctfdir;

sub parse_options {
    $ctfdir = $ARGV[0];
}

sub cook_babeltrace_trace {
    die "CTF trace directory not specified" unless defined $ctfdir;
    open BABELTRACE, "babeltrace --clock-seconds $ctfdir |" or die "Can't read $ctfdir with babeltrace";
    my $first_timestamp; # for trace_time account
    # per-stream hashes
    my %prev_timestamp; # for timestamp_delta account
    my %file_per_stream;
    while (<BABELTRACE>) {
        if (/^\[([^ ]+)\] .*babeltrace:lttng_live_received_index: .*stream_id = ([^ ,]+).*timestamp_begin = ([^ ,]+).*timestamp_end = ([^ ,]+).*$/) {

            # All values unless explcitly specified are reals representing seconds
            my $timestamp = $1;
            my $stream_id = $2;

            $first_timestamp = $timestamp unless defined($first_timestamp);
            my $trace_time = $timestamp - $first_timestamp;

            $prev_timestamp{$stream_id} = $timestamp unless defined($prev_timestamp{$stream_id});
            my $timestamp_delta = $timestamp - $prev_timestamp{$stream_id};
            $prev_timestamp{$stream_id} = $timestamp;

            # Convert from LTTng 64-bit integer timestamp
            my $index_timestamp_begin = $3 / MILLIARD;
            my $index_timestamp_end = $4 / MILLIARD;
            my $index_size = $index_timestamp_end - $index_timestamp_begin;

            my $diff_begin = $timestamp - $index_timestamp_begin;
            my $diff_end = $timestamp - $index_timestamp_end;

            if (!defined $file_per_stream{$stream_id}) {
                my $filename = "babeltrace-timings.$stream_id.dat";
                open $file_per_stream{$stream_id}, ">$filename" or die "Can't open output file $filename for writing";
            }
            # Field numbers for Gnuplot:
            #            1           2              3            4           5
            print {$file_per_stream{$stream_id}} "" .
                  "$trace_time $timestamp_delta $index_size $diff_begin $diff_end\n";
        }
    }
    for my $key (keys %file_per_stream) {
        close $file_per_stream{$key};
    }
}

sub main {
    parse_options();
    cook_babeltrace_trace();
}

main();
