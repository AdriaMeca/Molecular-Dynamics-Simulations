set terminal cairolatex pdf standalone header "\\usepackage{../packages/figure_definitions}"
set output "../figures/euler_energies_01.tex"

file = "../data/thermodynamics_01_03.dat"

xsep = 0.15
ysep = 0.15

plot_left = 0.12
plot_width = 0.35
plot_height = 0.40

p1_lmargin = plot_left
p1_rmargin = p1_lmargin + plot_width
p1_bmargin = 1.00 - 0.12
p1_tmargin = p1_bmargin - plot_height

p2_lmargin = p1_rmargin + xsep
p2_rmargin = p2_lmargin + plot_width
p2_bmargin = p1_bmargin
p2_tmargin = p1_tmargin

p3_lmargin = p1_lmargin
p3_rmargin = p2_rmargin
p3_bmargin = p1_tmargin - ysep
p3_tmargin = p3_bmargin - plot_height/2

set obj rect \
  at screen plot_left+plot_width+xsep/2,0.95 size char strlen('dt=10-4r.u.'),char 1 \
  fc rgb "gray"
set label '$\delta t=10^{-4}\unit{r.u.}$' \
  at screen plot_left+plot_width+xsep/2,0.95 \
  center front

x = 0.2
xoff = x / 10.

set xrange [0:1]

set xtics offset 0,0.4
set ytics offset 0.4,0

set xlabel offset 0,1.0
set ylabel offset 1.7,0

set xtics format '%.1f'
set ytics format '%.1f'

set xlabel '$t\,(\sigma\sqrt{m/\epsilon})$'

set multiplot

#Plot 1.
set lmargin at screen p1_lmargin
set rmargin at screen p1_rmargin
set bmargin at screen p1_bmargin
set tmargin at screen p1_tmargin

y = 1
yoff = y / 10.
set offset xoff,xoff,yoff,yoff

set yrange [0:5]

set ylabel '$U\,(10^{3}\epsilon)$'

plot file u 1:(10**-3*$3) w l ls 1 lw 2 notitle

#Plot 2.
set lmargin at screen p2_lmargin
set rmargin at screen p2_rmargin
set bmargin at screen p2_bmargin
set tmargin at screen p2_tmargin

y = 0.2
yoff = y / 10.
set offset xoff,xoff,yoff,yoff

set key horizontal \
  at screen (p2_lmargin+p2_rmargin)/2,p2_bmargin+0.03 \
  center samplen 2 width 1.5

set yrange [1.4:2.8]

set ylabel 'Energy$\,(10^{4}\epsilon)$'

plot file u 1:(10**-4*$2) w l ls 2 lw 2 t '$K$',\
     file u 1:(10**-4*($2+$3)) w l ls 3 lw 2 t '$E$'

#Plot 3.
set lmargin at screen p3_lmargin
set rmargin at screen p3_rmargin
set bmargin at screen p3_bmargin
set tmargin at screen p3_tmargin

set offset xoff,xoff,0,0

unset key

set yrange [1.6:2.0]
set ytics 1.6,0.2,2.0

set ylabel '$P\,(10^{2}\sqrt{m\epsilon})$'

plot file u 1:(10**-2*$4) w l ls 4 lw 3 notitle

unset multiplot