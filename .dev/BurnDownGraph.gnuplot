#!/usr/bin/gnuplot

set terminal svg size 640,350 dynamic enhanced font 'Verdana,10'
set output 'BurnDownGraph.svg'
#set terminal wxt enhanced
#set terminal x11; set out
#set term qt
#set terminal dumb 250 70

DATA = "tempdata.csv"
set datafile separator ','

stats DATA nooutput
Ncolumns = STATS_columns

set style line 100 linetype 0 linecolor rgb "grey" linewidth 0.5

set xdata time
set timefmt "%Y-%m-%d"
set format x "%Y-%m-%d"

set ytics scale 0.5 nomirror
set y2tics scale 0.5 nomirror
set xtics scale 0.5
unset mxtics

set yrange [0:]
set y2range [0:]

set grid y linestyle 100

set lmargin 10
set rmargin 10
set bmargin 3

set multiplot layout 2,1

set ylabel "number of files"
set y2label "hours used"

plot DATA using 1:6 with lines linewidth 1.5 linecolor rgb "dark-grey" title "time used" axis x1y2, \
       '' using 1:10:(86400) with boxes fill solid border -1 linecolor rgb "black" fc rgb "#ddaa55" title "completed files" axis x1y1, \
       '' using 1:($5-$10) with linespoints pointtype 7 pointsize 0.8 linewidth 2 linecolor rgb "#2255bb" title "remaining lines" axis x1y1

set ylabel "lines of code"
set format y "%2.0t×10^{%L}"
unset y2label
unset y2tics
set xlabel "iteration timeline"

plot DATA using 1:9:(86400) with boxes fill solid border -1 linecolor rgb "black" fc rgb "#ddaa55" title "completed lines" axis x1y1, \
       '' using 1:($4-$9) with linespoints pointtype 7 pointsize 0.8 linewidth 2 linecolor rgb "#2255bb" title "remaining lines" axis x1y1

unset multiplot

#set boxwidth 86400
#set style line 101 linewidth 3 linetype rgb "#f62aa0"
#plot DATA using 1:2 with lines linestyle 101 title columnhead axis x1y1, \
#       '' using 1:6 with lines title columnhead axis x1y2
#plot for [i=2:Ncolumns] DATA using 1:i with lines title columnhead
#plot for [i=1:Ncolumns] DATA using 0:i smooth csplines with lines title "columns ".i
