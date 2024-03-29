# MatlabThesis
This is the repository for the analysis of spike data to compare the two metrics for spiking 
synchronization: Vector Strength and Correlation Index.
Please note that some directory paths are still unique to my local repositories.



Folders:

+ _Analysis_Scripts:_ contains all .m scripts used to conduct specific analyses with (e.g. VS-CI plot for invivo and generated data, or code for comparing Joris' SPTCORR.m function with Go's calcSAC.m function.



+ _Raw_Data:_ contains invivo data from chicken NM (nucleus magnocellularis), chicken NL (nucleus laminaris), alligators NL, alligator NM, owls NM 



+ _Gen_Data:_ contains script which enables to generate data according to your liking. The folder "Raw_GenData" contains the data from one generation run of "generateData.m"



+ _Source_Code:_ this folder contains several subfolders with the code base from several different sources, e.g. the legacy code by Joris et al (2006), the Bruce-Zilany model
  (2018) and two repos by Go Ashida, namely "Ashida_code_2020" and "ANmodel". The latter mainly contains generated data using the Bruce-Zilany (2018) model.



+ _Utils:_ contains helper functions that are too general or widely used to be included in another module 
  and too small to claim their own module. They are clustered roughly in 3 different categories. The helper
  functions to analyze the invivo data, the AN/GBC data and the ANmod data. For each of these categories 
  there is at least a DataLoader function and a Preprocessing function.





