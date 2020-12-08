# MatlabThesis
This is the repository for the analysis of spike data to compare the two metrics for spiking 
synchronization: Vector Strength and Correlation Index.
Please note that some directory paths are still unique to my local repositories.



_folders:_

++++ Analysis_Scripts ++++
contains all .m scripts used to conduct specifiy analyses with (e.g. VS-CI plot for invivo and 
generated data, or code for comparing Joris' SPTCORR.m function with Go's calcSAC.m function.

++++ Raw_Data ++++
contains invivo data from chicken NM (nucleus magnocellularis), chicken NL (nucleus laminaris),
alligators NL, alligator NM, owls NM 

++++ Gen_Data ++++
contains script which enables to generate data according to your liking. The folder "Raw_GenData"
contains the data from one generation run of "generateData.m"

++++ Source_Code ++++
this folder contains several subfolders with the code base from several different sources, e.g.
the legacy code by Joris et al (2006), the Bruce-Zilany model (2018) and two repos by Go Ashida
("ANmodel" and "Ashida_code_2020").

++++ Utils ++++
contains helper functions that are too general or widely used to be included in another module 
and too small to claim their own module.

