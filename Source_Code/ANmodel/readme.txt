- ANdata: Containing simulated AN data at varied frequencies (200-3000 Hz, 40 and 70 dB). 
 After unzipping, you will have 58 matlab data files. These files were created by the 
 script trainAN.m, which internally uses the Bruce-Zilany-2018 model. Each file contains 
 AN spike trains for 8000 repetitions, which are required for simulating GBC responses 
 (20 AN inputs x 400 trials = 8000 repetitions). You can use the first 400 repetitions
 for our manuscript (and the remaining data for checking the reproducibility acrosss trials).

- GBCdata: Containing simulated GBC data at varied frequencies (200-3000 Hz, 40 and 70 dB).
 These files were created by the script trainGBC.m, which internally uses the AN data and 
 the GBC model (GBCmodelACC.m).

- plots: Containing PSTHs and calculated VS values for the simulated AN/GBC data. 
 These plots were created by the script plotANGBC.m, which internally uses the spike trains
 in the folders ANdata and GBC data. This plot script internally calls calcVSstats.m for the
 calculation of VS and PSTH (and some other quantities like ISIH, which you can just ignore)