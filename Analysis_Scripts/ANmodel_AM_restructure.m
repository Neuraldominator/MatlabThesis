%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script analyzes the amplitude modulated (AM) data from the folder
% "..\Source_Code\ANmodel\ANmod".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load data
d = load("..\Source_Code\ANmodel\ANmod\ANmod7000Hz100Hz40dB4SAC.mat");
% when loaded as a struct, the following fields show up (in order):
% ANout: binary spike trains (800x20000)
% Cardb: decibel level [db SPL]
% CarFq: carrier frequency [Hz], 7000 or 10500 here
% EnvFq: envelope modulation frequency [Hz]
% WavSound: stimulus sound waveform
% tvms: time vector [ms]
% vlHC: inner hair cell (IHC) relative transmembrane potential in [V]

%% add paths
addpath("..\Source_Code\Ashida_2020_code\invivo")
addpath("..\Utils")

%% preprocessing and metric calculation
path_AM = "..\Source_Code\ANmodel\ANmod\";
BW = 0.05;  % coincidence window [ms]

VSCI = calcMetrics_genDataAM(path_AM, BW);

%% save results in .mat file
save("VSCI_ANmodel_AM.mat", "VSCI");

