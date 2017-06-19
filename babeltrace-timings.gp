#!/usr/bin/gnuplot

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

reset
files = system("ls -1 *.dat")
set terminal png size 1920, 1200

set output "plot-time-delta.png"
set xlabel "Trace time (seconds)"
set ylabel "Timestamp_d (seconds)"
plot for [file in files] \
    file using 1:2 title sprintf("Timestamp_d for %s", file) axes x1y1 with lines

set output "plot-index-size.png"
set xlabel "Trace time (seconds)"
set ylabel "Index size (seconds)"
plot for [file in files] \
    file using 1:3 title sprintf("Index size for %s", file) axes x1y1 with lines

set output "plot-index-lag.png"
set xlabel "Trace time (seconds)"
set ylabel "Lag (seconds)"
plot for [file in files] \
    file using 1:4 title sprintf("Index lag for %s", file) axes x1y1 with lines

