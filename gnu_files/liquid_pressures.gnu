set terminal png
set output "../figures/liquid_pressures.png"

file = '../data/thermodynamics_02_0'
nums = '2 4 6 8'

#Offset.
set offset 2,2,0,0

#Key.
set key top left

#Range.
set xrange [0:100]

#Labels.
set xlabel 'Time'
set ylabel 'Pressure'

plot for [i=1:4] file . word(nums, i) . '.dat' every 100:::::0 u 1:5 w l notitle,\
     for [i=1:4] NaN w l ls i lw 2 t 'rho=0.' . word(nums, i)