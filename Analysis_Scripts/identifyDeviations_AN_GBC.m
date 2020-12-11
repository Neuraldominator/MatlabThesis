%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script identifies the deviations from the plot in 
% "analysis_AN_GBC.m". This script supports exploring the data rather than
% analyzing it.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler (Dec 2020)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load("VSCI_ANmodel.mat");  % load the VS-CI points
addpath("..\Utils\")  % add helper functions


%% For the AN fibers (70db)
path0 = "..\Source_Code\ANmodel\ANdata\ANdata0\";
path1 = "..\Source_Code\ANmodel\ANdata\ANdata1\";
path2 = "..\Source_Code\ANmodel\ANdata\ANdata2\";

db = 70;  % decibel level: 40 or 70
celltype = "AN";  % cell type: "AN" or "GBC"
sf = 100;  % [kHz]
cutoff = 15;  % [ms]

% preprocess the ANdata
data0 = PreprocessingSpikes_genData(path0, db, celltype, sf, cutoff);
data1 = PreprocessingSpikes_genData(path1, db, celltype, sf, cutoff);
data2 = PreprocessingSpikes_genData(path2, db, celltype, sf, cutoff);

%% Further processing and exploration
data_cell = vertcat(data0.ANdata70db, data1.ANdata70db, data2.ANdata70db);

% Explore: The VS-CI values of the (AN,70db) dataset 
VSCI_AN70(2,:);  % 200 Hz
VSCI_AN70(3,:);  % 300 Hz
VSCI_AN70(4,:);  % 400 Hz

% find out the corresponding stimulation frequencies
[f1,f2,f3]=data_cell{2:4,3};

%% For the GBC fibers (40db)
path = "..\Source_Code\ANmodel\GBCdata\";
db = 40;  % decibel level: 40 or 70
celltype = "GBC";  % cell type: "AN" or "GBC"
sf = 100;  % [kHz]
cutoff = 15;  % [ms]

% preprocess the ANdata
data = PreprocessingSpikes_genData(path, db, celltype, sf, cutoff);

%% Further exploration

% Explore: The GBC 40db dataset
VSCI_GBC40(12,:)  % corresponds to the "green star outlier" in the plot
f = data.GBCdata40db{12,3};  % find out the corresponding stimulation 
                             % frequency

