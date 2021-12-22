set terminal png
set output "../figures/liquid_energies.png"

file1 = "../data/thermodynamics_02_02.dat"
file2 = "../data/thermodynamics_02_04.dat"
file3 = "../data/thermodynamics_02_06.dat"
file4 = "../data/thermodynamics_02_08.dat"

#Margins.
xsep = 0.05
ysep = 0.10

plot_left = 0.10
plot_width = 0.40
plot_height = 0.35

p1_lmargin = plot_left
p1_rmargin = p1_lmargin + plot_width
p1_bmargin = 1.00 - 0.10
p1_tmargin = p1_bmargin - plot_height

p2_lmargin = p1_rmargin + xsep
p2_rmargin = p2_lmargin + plot_width
p2_bmargin = p1_bmargin
p2_tmargin = p1_tmargin

p3_lmargin = p1_lmargin
p3_rmargin = p3_lmargin + plot_width
p3_bmargin = p1_tmargin - ysep
p3_tmargin = p3_bmargin - plot_height

p4_lmargin = p2_lmargin
p4_rmargin = p4_lmargin + plot_width
p4_bmargin = p3_bmargin
p4_tmargin = p3_tmargin

#Offset.
set offset 2,2,10,10

#Range.
set xrange [0:100]
set yrange [-200:600]

set multiplot

#Plot 1.
set lmargin at screen p1_lmargin
set rmargin at screen p1_rmargin
set bmargin at screen p1_bmargin
set tmargin at screen p1_tmargin

#Subtitle.
set label 1 'rho=0.2' at graph 0.5,0.9 center

#We remove the numbers of the x axis.
set format x ''
#We move the numbers of the y axis.
set ytics offset 0.4,0

#Label of the y axis.
set ylabel 'Energy' offset 1.7,0

plot file1 every 1000:::::0 u 1:2 w l ls 1 notitle,\
     file1 every 1000:::::0 u 1:3 w l ls 2 notitle,\
     file1 every 1000:::::0 u 1:($2+$3) w l ls 3 notitle

#Plot 2.
set lmargin at screen p2_lmargin
set rmargin at screen p2_rmargin
set bmargin at screen p2_bmargin
set tmargin at screen p2_tmargin

#Subtitle.
set label 2 'rho=0.4' at graph 0.5,0.9 center
unset label 1

#We remove the label and the numbers of the y axis.
set format y ''
unset ylabel

plot file2 every 1000:::::0 u 1:2 w l ls 1 notitle,\
     file2 every 1000:::::0 u 1:3 w l ls 2 notitle,\
     file2 every 1000:::::0 u 1:($2+$3) w l ls 3 notitle

#Plot 3.
set lmargin at screen p3_lmargin
set rmargin at screen p3_rmargin
set bmargin at screen p3_bmargin
set tmargin at screen p3_tmargin

#Subtitle.
set label 3 'rho=0.6' at graph 0.5,0.9 center
unset label 2

#We reset the numbers of the axes.
set format x
set format y

#We move the numbers of the axes.
set xtics offset 0,0.4
set ytics offset 0.4,0

#Labels.
set xlabel 'Time' offset 0,0.7
set ylabel 'Energy' offset 1.7,0

plot file3 every 1000:::::0 u 1:2 w l ls 1 notitle,\
     file3 every 1000:::::0 u 1:3 w l ls 2 notitle,\
     file3 every 1000:::::0 u 1:($2+$3) w l ls 3 notitle

#Plot 4.
set lmargin at screen p4_lmargin
set rmargin at screen p4_rmargin
set bmargin at screen p4_bmargin
set tmargin at screen p4_tmargin

#Subtitle.
set label 4 'rho=0.8' at graph 0.5,0.9 center
unset label 3

#Key.
set key at screen p1_rmargin+xsep/2,0.95 center maxrows 1 width 2 samplen 2 box

#We remove the label and the numbers of the y axis.
set format y ''
unset ylabel

plot file4 every 1000:::::0 u 1:2 w l ls 1 notitle, NaN w l ls 1 lw 2 t "K",\
     file4 every 1000:::::0 u 1:3 w l ls 2 notitle, NaN w l ls 2 lw 2 t "U",\
     file4 every 1000:::::0 u 1:($2+$3) w l ls 3 notitle, NaN w l ls 3 lw 2 t "E"