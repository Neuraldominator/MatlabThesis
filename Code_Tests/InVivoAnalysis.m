%% Re-Analyze the invivo data 
% Based on the script SAC_comparison.m of this folder, we know that the 
% analysis code of Ashida and Joris produce the same results. For this
% analysis, we use Ashida's code and reproduce the VS-CI curve.

%% 1. Load the repo by Ashida
% set working directory
path = strcat("C:\Users\Dominik\Documents\Uni_Oldenburg\5th_semester\", ...
              "\MasterThesis\MatlabThesis\Code_Tests\");
cd(path)

% access the repo from Ashida
FunctionLoader("..\Source_Code\Ashida_2020_code\invivo")

%% load the preprocessed data from all animals and all cell types
folders = ["chickNL", "chickNM", "gatorNL", "gatorNM", "owlNM"];
cutoff = 15;  % onset response cutoff [ms]
R_thresh = 30;  % driven spike rate threshold [sp/sec]
[spike_data, Rout] = PreprocessingSpikes(folders, R_thresh, cutoff);