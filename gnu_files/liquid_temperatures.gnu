set terminal png
set output "../figures/liquid_temperatures.png"

file = '../data/thermodynamics_02_0'
nums = '2 4 6 8'

#Offset.
set offset 2,2,0.05,0.05

#Key.
set key bottom right

#Range.
set xrange [0:100]
set yrange [0:2.5]

#Format of the y tics.
set ytics format '%.1f'

#Labels.
set xlabel 'Time'
set ylabel 'Temperature'

plot for [i=1:4] file . word(nums, i) . '.dat' every 100:::::0 u 1:4 w l notitle,\
     for [i=1:4] NaN w l ls i lw 2 t 'rho=0.' . word(nums, i)