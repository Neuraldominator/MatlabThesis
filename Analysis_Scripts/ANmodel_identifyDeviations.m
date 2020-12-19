%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script identifies the deviations from the plot in 
% "ANmodel_VSCI_plot.m". This script supports exploring the data rather
% than analyzing it.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler (Dec 2020)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load("VSCI_ANmodel.mat");  % load the VS-CI points
addpath("..\Utils\")  % add helper functions


%% For the AN fibers 
path0 = "..\Source_Code\ANmodel\ANdata\ANdata0\";
path1 = "..\Source_Code\ANmodel\ANdata\ANdata1\";
path2 = "..\Source_Code\ANmodel\ANdata\ANdata2\";

%% for AN, 40db
db = 40;  % decibel level: 40 or 70
celltype = "AN";  % cell type: "AN" or "GBC"
sf = 100;  % [kHz]
cutoff = 15;  % [ms]

% preprocess the ANdata
data0 = PreprocessingSpikes_genData(path0, db, celltype, sf, cutoff);
data1 = PreprocessingSpikes_genData(path1, db, celltype, sf, cutoff);
data2 = PreprocessingSpikes_genData(path2, db, celltype, sf, cutoff);

% Further processing and exploration
data_cell_AN40 = vertcat(data0.ANdata40db, data1.ANdata40db, data2.ANdata40db);

% Explore: The VS-CI values of the (AN,40db) dataset 
VSCI_AN40(2,:);  % f1 = 200 Hz (see couple of lines below)
VSCI_AN40(3,:);  % f2 = 300 Hz (see couple of lines below)
VSCI_AN40(4,:);  % f3 = 400 Hz (see couple of lines below)

% find out the corresponding stimulation frequencies
[f1_40,f2_40,f3_40]=data_cell_AN40{2:4,3};

%% for AN, 70db
db = 70;  % decibel level: 40 or 70
celltype = "AN";  % cell type: "AN" or "GBC"
sf = 100;  % [kHz]
cutoff = 15;  % [ms]

% preprocess the ANdata
data0 = PreprocessingSpikes_genData(path0, db, celltype, sf, cutoff);
data1 = PreprocessingSpikes_genData(path1, db, celltype, sf, cutoff);
data2 = PreprocessingSpikes_genData(path2, db, celltype, sf, cutoff);

% Further processing and exploration
data_cell_AN70 = vertcat(data0.ANdata70db, data1.ANdata70db, data2.ANdata70db);

% Explore: The VS-CI values of the (AN,70db) dataset 
VSCI_AN70(2,:);  % f1 = 200 Hz (see couple of lines below)
VSCI_AN70(3,:);  % f2 = 300 Hz (see couple of lines below)
VSCI_AN70(4,:);  % f3 = 400 Hz (see couple of lines below)

% find out the corresponding stimulation frequencies
[f1_70,f2_70,f3_70]=data_cell_AN70{2:4,3};

%% For the GBC fibers (40db)
path = "..\Source_Code\ANmodel\GBCdata\";
db = 40;  % decibel level: 40 or 70
celltype = "GBC";  % cell type: "AN" or "GBC"
sf = 100;  % [kHz]
cutoff = 15;  % [ms]

% preprocess the ANdata
data_GBC40 = PreprocessingSpikes_genData(path, db, celltype, sf, cutoff);

% Further exploration

% Explore: The GBC 40db dataset
VSCI_GBC40(12,:);  % 200Hz (corresponds to the "green star outliers")
VSCI_GBC40(23,:);  % 300Hz
VSCI_GBC40(24,:);  % 400Hz

% find out the corresponding stimulation frequencies
[f4_40,f5_40,f6_40] = data_GBC40.GBCdata40db{[12, 23, 24],3};  
%% For the GBC fibers (70db)
path = "..\Source_Code\ANmodel\GBCdata\";
db = 70;  % decibel level: 40 or 70
celltype = "GBC";  % cell type: "AN" or "GBC"
sf = 100;  % [kHz]
cutoff = 15;  % [ms]

% preprocess the ANdata
data_GBC70 = PreprocessingSpikes_genData(path, db, celltype, sf, cutoff);

% Further exploration
% Explore: The GBC 70db dataset
VSCI_GBC70(12,:);  % corresponds to 200Hz, utmost outlier (yellow square)
VSCI_GBC70(23,:);  % 300Hz
VSCI_GBC70(24,:);  % 400Hz

% find out the corresponding stimulation frequencies
[f4_70,f5_70,f6_70] = data_GBC70.GBCdata70db{[12, 23, 24],3}; 

