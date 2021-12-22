set terminal cairolatex pdf standalone header "\\usepackage{../packages/figure_definitions}"
set output "../figures/vel_verlet_histogram.tex"

file = "../data/velocity_histogram.dat"

set style histogram rowstacked gap 0
set style fill solid 0.7 noborder

#Margins.
plot_height = 0.75
plot_width = 0.35
xsep = 0.12

plot1_lmargin = 0.12
plot1_rmargin = plot1_lmargin + plot_width
plot1_bmargin = 1.00 - 0.10
plot1_tmargin = plot1_bmargin - plot_height

plot2_lmargin = plot1_rmargin + xsep
plot2_rmargin = plot2_lmargin + plot_width
plot2_bmargin = plot1_bmargin
plot2_tmargin = plot1_tmargin

#Tics offset.
set xtics offset 0,0.4
set ytics offset 0.4,0

#Labels offset.
set xlabel offset 0,0.7
set ylabel offset 1.7,0

#Tics format.
set ytics format '%.2f'

#Labels.
set xlabel '$v^{\alpha}\,(\sqrt{\epsilon/m})$'
set ylabel 'Normalized number of occurrences'

set multiplot

#Plot 1.
set lmargin at screen plot1_lmargin
set rmargin at screen plot1_rmargin
set bmargin at screen plot1_bmargin
set tmargin at screen plot1_tmargin

set title 'Initial distribution' offset 0,-0.7

#Ranges.
set xrange [-15:15]

plot file index 0 u ($2>=0 ? $2+5 : $2):1 smooth freq with boxes notitle

#Plot 2.
set lmargin at screen plot2_lmargin
set rmargin at screen plot2_rmargin
set bmargin at screen plot2_bmargin
set tmargin at screen plot2_tmargin

set title 'Equilibrium distribution'

set key top center samplen 2 box

#Ranges.
set xrange [-40:40]
set yrange [0:0.055]
set xtics -40,20,40

#Labels.
unset ylabel

T = 85.9
f(x) = exp(-x**2/2/T) / sqrt(2*pi*T)

plot file index 1 u 2:1 smooth freq with boxes notitle,\
     f(x) w filledcurves fs transparent solid 0.3 border lw 3 t 'M-B($T=85.9$)'

unset multiplot
