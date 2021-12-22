from math import sqrt
from sys import argv


_, filename = argv

n = 0

sum_x = 0.0
sum_y = 0.0

sum_x2 = 0.0
sum_y2 = 0.0
sum_xy = 0.0

with open(filename, 'r') as inputfile:
    for row in inputfile:
        if row.startswith('#'): continue
        x, y = map(float, row.strip().split())

        #Equilibrium.
        if x >= 20:
            n += 1

            sum_x += x
            sum_y += y

            sum_x2 += x * x
            sum_y2 += y * y
            sum_xy += x * y

delta = n*sum_x2 - sum_x*sum_x
a = (n*sum_xy - sum_x*sum_y) / delta
b = (sum_x2*sum_y - sum_x*sum_xy) / delta

mean_x = sum_x / n
mean_y = sum_y / n

std_x = sqrt((sum_x2-n*mean_x*mean_x)/(n-1))
std_y = sqrt((sum_y2-n*mean_y*mean_y)/(n-1))

std_xy = (sum_xy-n*mean_x*mean_y) / (n-1)

r2 = (std_xy / std_x / std_y)**2

err_y = std_y * sqrt((n-1)*(1-r2)/(n-2))
err_a = err_y * sqrt(n/delta)
err_b = err_y * sqrt(sum_x2/delta)

print(f"""
    a={a}+-{err_a},
    b={b}+-{err_b},
    r2={r2}.
""")
