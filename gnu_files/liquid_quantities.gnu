set terminal cairolatex pdf standalone header "\\usepackage{../packages/figure_definitions}"
set output "../figures/liquid_quantities.tex"

file = "../data/liquid_quantities.dat"

#Constants.
NA = 6.02214076e+23

#Parameters.
sigma = 3.4e-10
epsilon = 0.998
m = 40

#Combinations.
density = m / NA / (10**2*sigma)**3
pressure = (10**-11) * (10**3*epsilon) / NA / sigma**3

#Margins.
xsep = 0.15
ysep = 0.15

plot_left = 0.12
plot_width = 0.35
plot_height = 0.34

p1_lmargin = plot_left
p1_rmargin = p1_lmargin + plot_width
p1_bmargin = 1.00 - 0.05
p1_tmargin = p1_bmargin - plot_height

p2_lmargin = p1_rmargin + xsep
p2_rmargin = p2_lmargin + plot_width
p2_bmargin = p1_bmargin
p2_tmargin = p1_tmargin

p3_lmargin = p1_lmargin
p3_rmargin = p1_rmargin
p3_bmargin = p1_tmargin - ysep
p3_tmargin = p3_bmargin - plot_height

p4_lmargin = p2_lmargin
p4_rmargin = p2_rmargin
p4_bmargin = p1_tmargin - ysep
p4_tmargin = p4_bmargin - plot_height

#Special xrange that centers the points horizontally.
set xrange [0.2:1.49]

#Offset of the tics.
set xtics offset 0,0.4
set ytics offset 0.4,0

#Offset of the labels.
set xlabel offset 0,1.0
set ylabel offset 1.7,0

#Format of the x tics.
set xtics format '%.1f'

#Label of the x axis.
set xlabel '$\rho\,(\mathrm{g/cm^{3}})$'

set multiplot

#Plot 1.
set lmargin at screen p1_lmargin
set rmargin at screen p1_rmargin
set bmargin at screen p1_bmargin
set tmargin at screen p1_tmargin

set ylabel '$K\,(\mathrm{kJ/mol})$'

plot file u ($1*density):($2*epsilon):($3*epsilon) w yerrorl ls 1 pt 1 noti

#Plot 2.
set lmargin at screen p2_lmargin
set rmargin at screen p2_rmargin
set bmargin at screen p2_bmargin
set tmargin at screen p2_tmargin

set ylabel '$U\,(\mathrm{kJ/mol})$'

plot file u ($1*density):($4*epsilon):($5*epsilon) w yerrorl ls 2 pt 3 noti

#Plot 3.
set lmargin at screen p3_lmargin
set rmargin at screen p3_rmargin
set bmargin at screen p3_bmargin
set tmargin at screen p3_tmargin

set ylabel '$E\,(\mathrm{kJ/mol})$'

plot file u ($1*density):($6*epsilon):($7*epsilon) w yerrorl ls 3 pt 5 noti

#Plot 4.
set lmargin at screen p4_lmargin
set rmargin at screen p4_rmargin
set bmargin at screen p4_bmargin
set tmargin at screen p4_tmargin

set ytics format '%.1f'

set ylabel '$P\,(10^{11}\,\mathrm{Pa})$'

plot file u ($1*density):($8*pressure):($9*pressure) w yerrorl ls 4 pt 7 noti

unset multiplot
