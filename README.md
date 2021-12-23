# Molecular Dynamics Simulations

This repository contains the codes and the final report of the Molecular Dynamics part of the Molecular Modeling course of the MSc in Complex Systems and Biophysics at the UB.

## Overview

The folder *main_programs/* contains the **Fortran** codes of the first, second and extra parts of the project. They use the procedures of the module *modules/mds.f90*, which has all the relevant algorithms that we have written in the lab sessions.

The directories *linux_compilation/* and *windows_compilation/* contain scripts that run the main programs in several terminals simultaneously for both operating systems. They use the *temp/* folder, so do not delete it.

The results of the simulations are stored in the *data/* folder. Since **GitHub** has a size limitation, I have not been able to upload all the files.

I have used **Python** to process the data further. For example, in the folder called *py_files/* there is an script that computes the errors of the liquid's energies and pressure using the *block average method*.

The folder *gnu_files/* has all the **Gnuplot** files used to create the figures of the report. They are stored in the *figures/* directory, which has some exclusive figures that do not appear in the final report.

Finally, the *report/* folder contains the manuscript of the final report, and its **LaTeX** definitions are inside the *packages/* folder.
