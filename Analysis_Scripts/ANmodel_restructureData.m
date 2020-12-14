%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis script for AN (Auditory Nerve) and GBC (Globular Bushy Cell) 
% data in the folders "..\Source_Code\ANmodel\ANdata" and 
% "..\Source_Code\ANmodel\GBCdata". The folder ANdata is subdivided into 3
% folders called "ANdata0", "ANdata1" and "ANdata2". The aim of this script
% is to preprocess the data to create the infamous VS-CI plot for this 
% project (this is done in the scipt "ANmodel_VSCI_plot.m").
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1.1 Add data file paths (AN)

% Auditory Nerve Data
path_AN0 = "..\Source_Code\ANmodel\ANdata\ANdata0\";
path_AN1 = "..\Source_Code\ANmodel\ANdata\ANdata1\";
path_AN2 = "..\Source_Code\ANmodel\ANdata\ANdata2\";

% Variables stored in these files:
% "ANout" are the binary spike trains (the first 400 of the 8000)
% "PTdb" is the parameter containing the db value of the data set
% "PTfq" is the parameter containing the freq value [Hz] of the data set
% "WavSound" is the stimulus sound waveform
% "tvms" is the time vector [ms] (stimulus starts at time zero)
% "vlHC" is the inner hair cell (IHC) relative transmembrane potential [V]

%% 1.1 Add data file paths (Globular Bushy Cell Data)
path_GBC = "..\Source_Code\ANmodel\GBCdata\";

% Variables stored in these files:
% "BCout" are the binary spike trains (all of the 400 repetitions)
% "PTdb" is the parameter containing the db value of the data set
% "PTfq" is the parameter containing the freq value [Hz] of the data set
% "tvms" is the time vector [ms] (stimulus starts at time zero)

%% 2. Add source code paths
addpath("..\Source_Code\Ashida_2020_code\invivo")
addpath("..\Utils")

%% 3. Define analysis parameters
% idea: use the helper functions in the folder "Utils". For that, recreate
% the data structure used there. If not, define new functions based on the
% old ones which can deal with this data structure here.
%cutoff = 15;

% retrieve some relevant parameters from "..\Source_Code\ANmodel\trainAN.m"
%dt = 0.01; % [ms] time step -- 100kHz sampling rate
%epoch = 200;  % duration [ms] of entire simulation
%delay = 25;  % [ms] start of stimulus (5s ramping)

% set the start T1 and end T2 of the analysis window
%T1 = delay + cutoff;
%T2 = epoch;  % stimulus goes until very end of simulation
BW = 0.05;

%% 4. Arange the AN data in the fields of the Data struct  
VSCI_an0_40 = calcMetrics_genData(path_AN0, 40, "AN", BW);
VSCI_an0_70 = calcMetrics_genData(path_AN0, 70, "AN", BW);

VSCI_an1_40 = calcMetrics_genData(path_AN1, 40, "AN", BW);
VSCI_an1_70 = calcMetrics_genData(path_AN1, 70, "AN", BW);

VSCI_an2_40 = calcMetrics_genData(path_AN2, 40, "AN", BW);
VSCI_an2_70 = calcMetrics_genData(path_AN2, 70, "AN", BW);

% concatenate the 40db and 70db results
VSCI_AN40 = vertcat(VSCI_an0_40, VSCI_an1_40, VSCI_an2_40);
VSCI_AN70 = vertcat(VSCI_an0_70, VSCI_an1_70, VSCI_an2_70); 

%% 5. Arange the GBC data in the fields of the Data struct 
VSCI_GBC40 = calcMetrics_genData(path_GBC, 40, "GBC", BW);
VSCI_GBC70 = calcMetrics_genData(path_GBC, 70, "GBC", BW);

%% 6. Save the results
save("VSCI_ANmodel", "VSCI_AN40", "VSCI_AN70", "VSCI_GBC40", "VSCI_GBC70")