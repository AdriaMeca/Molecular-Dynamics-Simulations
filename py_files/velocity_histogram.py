import numpy as np


file1 = "../data/velocity_distribution.dat"
file2 = "../data/velocity_histogram.dat"

switch = True
ini_data, fin_data = [], []
with open(file1, 'r') as inputfile:
    for row in inputfile:
        if row.startswith('#'):
            continue
        if not row.strip():
            switch = False
            continue
        vls = list(map(float, row.strip().split()))
        if switch:
            ini_data += vls
        else:
            fin_data += vls

hist1, bins1 = np.histogram(ini_data, bins='fd', density=True)
hist2, bins2 = np.histogram(fin_data, bins='fd', density=True)

with open(file2, 'w') as outputfile:
    row = (2*'{:>26.16e}' + '\n')
    outputfile.write(f"#{'h':>25}{'b':>26}\n")
    for h, b in zip(hist1, bins1):
        outputfile.write(row.format(h, b))
    outputfile.write('\n\n')
    for h, b in zip(hist2, bins2):
        outputfile.write(row.format(h, b))