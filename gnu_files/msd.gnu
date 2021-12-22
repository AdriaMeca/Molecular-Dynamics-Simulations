set terminal cairolatex pdf standalone header "\\usepackage{../packages/figure_definitions}"
set output "../figures/msd.tex"

files = '../data/msd_0'
mean = '../data/mean_msd.dat'

set style line 9 lw 0 lc rgb 'gray'

#Parameters.
sigma = 3.4e-10
epsilon = 0.998
m = 40

#Combinations.
msd = (10**10*sigma)**2
time = (10**12) * sigma * sqrt(m/(10**6*epsilon))

#Linear regression parameters.
a = 11.1434 * (msd/time)
b = -247.38 * (msd)
f(x) = a*x + b

#Keys.
k1 = "Realizations"
k2 = "Mean"
k3 = "Fit"

#Offset.
set offset 5,5,0,0

#Legend.
set key bottom right samplen 2 width -2.5 box

#Fit equation.
set label "$f(x)=(59.846\\pm0.005)x+(-2859.7\\pm0.7)$,\n$r^{2}=0.995$." \
  at first 5,graph 0.9

#Range of the x axis.
set xrange [0:200]

#Labels.
set xlabel '$t\,(\mathrm{ps})$'
set ylabel '$\text{MSD}\,(\textup{\AA}^{2})$'

n = 9
plot for [i=0:n-1] sprintf("%s%d.dat", files, i) every 100 u ($1*time):($2*msd) w l ls 9 noti,\
     sprintf("%s%d.dat", files, n) every 100 u ($1*time):($2*msd) w l ls 9 noti, NaN w l ls 9 lw 2 t k1,\
     f(x) w l ls 2 lw 3 noti, NaN w l ls 2 lw 2 t k3,\
     mean every 10000 u ($1*time):($2*msd) w p ls 1 lw 2 ps 0.5 noti, NaN w p ls 1 lw 2 t k2
