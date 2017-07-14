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


# You can repare input files for this script like this:
# editcap -i 10 ~/work/case/TB-71114-tbctf-live/2017-07-13/localhost-multicore/01-all-defaults/lttng-live.pcap edit-cap-01/chunk-10sec.pcap
# capinfos -M -sc edit-cap-01/*.pcap | sed -n 's/^File size:\s\+//p' > edit-cap-01/cap-sizes.txt
# capinfos -M -sc edit-cap-01/*.pcap | sed -n 's/^Number of packets:\s\+//p' > edit-cap-01/cap-packets.txt
# cd edit-cap-01/
# ~/work/case/TB-71114-tbctf-live/babeltrace-timings/cap-stats.gp 


reset
set terminal png size 1920, 1200

set output "cap-stats.png"
set xlabel "Capture chunks"
set ylabel "Packets"
set y2label "Size"
set y2tics
plot "cap-packets.txt" using 1 title "Packets" axes x1y1 with lines, \
	"cap-sizes.txt" using 1 title "Sizes" axes x1y2 with boxes

