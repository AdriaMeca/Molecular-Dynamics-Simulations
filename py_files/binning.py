from os import listdir
from scipy.optimize import curve_fit
from scipy.special import expit

import numpy as np

def binning(old_data, m=[], std=[], p=[0], avg=[0.0]):
    isize = len(old_data)
    nb = isize // 2
    if nb < 100: return

    new_data = np.zeros(nb)

    #m = 1.
    if p[0] == 0:
        #Total average.
        avg[0] = 0.0
        for i in range(isize):
            avg[0] += old_data[i]
        avg[0] /= isize

        var = 0.0
        for i in range(isize):
            var += (old_data[i]-avg[0])**2
        var /= isize * (isize-1)
        m.append(2**p[0])
        std.append(np.sqrt(var))

    #m = 2, 4, 8, 16, 32, etc.
    j = 0
    var = 0.0
    for i in range(0, isize-1, 2):
        avg_m = (old_data[i]+old_data[i+1]) / 2
        var += (avg_m-avg[0])**2
        new_data[j] = avg_m
        j += 1
    var /= nb * (nb-1)

    p[0] += 1
    m.append(2**p[0])
    std.append(np.sqrt(var))

    binning(new_data)

    return avg[0], m, std

def fit(x, a, b, t):
    return a - b*expit(-x/t)


path = '../data/'
files = list(filter(lambda s: '02_0' in s, listdir(path)))

for j, file in enumerate(files):
    data = np.zeros((8*10**5, 4))
    with open(path+file, 'r') as inputfile:
        idx = 0
        for row in inputfile:
            if (not row) or (row.startswith('#')):
                continue
            t, k, u, _, p = map(float, row.strip().split())
            if t >= 20:
                data[idx, :] += [k, u, k+u, p]
                idx += 1
    print(f'{0.2*(j+1):>18.8e}', end='')
    for i in range(4):
        avg, m_data, s_data = binning(data[:, i])
        binning.__defaults__ = ([], [], [0], [0.0])

        params, _ = curve_fit(fit, m_data, s_data)

        row = (2*'{:>18.8e}').format(avg, params[0])
        print(row, end='')
    print()
