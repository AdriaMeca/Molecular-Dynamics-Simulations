from os import listdir

import numpy as np

my_dir = '../data/'
my_files = list(filter(lambda s: s.startswith('msd'), listdir(my_dir)))

time = np.zeros(2+10**6)
mean_msd = np.zeros(2+10**6)
for i, file in enumerate(my_files):
    with open(my_dir+file, 'r') as inputfile:
        for j, row in enumerate(inputfile):
            if row.startswith('#'):
                continue

            t, msd = map(float, row.strip().split())
            mean_msd[j] += msd
            if i == 0:
                time[j] += t
mean_msd /= len(my_files)

with open(f'{my_dir}mean_msd.dat', 'w') as outputfile:
    header = f"#{'t':>25}{'msd':>26}\n"
    outputfile.write(header)
    for t, msd in zip(time, mean_msd):
        row = (2*'{:>26.16e}' + '\n').format(t, msd)
        outputfile.write(row)
