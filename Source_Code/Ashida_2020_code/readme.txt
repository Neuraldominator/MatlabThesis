Files in this folder
Oct 2020, Go Ashida (go.ashida@uni-oldenburg.de)

++++ invivo ++++

- data  
Folder containing in vivo recording data of chicks(NM/NL), gators(NM/NL), and owls(NM).

- plotCIvivo.m 
Analyzing and plotting the VS and CI of in vivo data. 
"calcPhaseHist.m" (for calculating VS) and "calcSAC.m" (for calculating SAC/CI) are internally used. 
"VSCIall.pdf" and "VSCIall.png" are the output figure files. 
Data with a spike rate over 30 (spikes/sec) and a spike number over 400 (spikes) are plotted. (line 94)

++++ decay ++++

- testSACdecay.m
Script to test the effect of limited analysis time length on SAC. 
"PhaseLock.m" is internally used to make phase-locked spike trains. 
"calcPhaseHist.m" and "calcSAC.m" are internally used for the analysis of generated data. 


++++ binwidth ++++

- makeSACtrains.m 
Script to make phase-locked spike trains.
"PhaseLock.m" is internally used. 
"SPv60all.mat" is the default output file. 
It may take a few hours to run this script. 

- getSACstats.m 
Script to calculate SAC/CI for varied bin widths. 
"calcSAC.m" is internally used. 
"SPv60all.mat" is the default input file. 
"CIv60sll.mat" is the default output file.
It may take more than several hours to run this script. 

- plotSACstats.m 
Script to plot the effect of bin width on CI. 
"CIv60sll.mat" is the default input file. 
"binwidthsim.pdf" and "binwidthsim.png" are the output figure files. 

