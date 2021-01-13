%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Re-analyze the invivo data in the folder "Raw_Data". Based on the script
% "SAC_comparison.m" of the current folder, we know that the analysis code
% of Ashida and Joris produce the same results. For this analysis, we use 
% Ashida's code and reproduce the VS-CI plot for the invivo data.

%% 1. Load the repo by Ashida
% set current working directory
path = strcat("C:\Users\Dominik\Documents\Uni_Oldenburg\5th_semester\", ...
              "\MasterThesis\MatlabThesis\Analysis_Scripts\");
cd(path)

% access the repo from Ashida
addpath("..\Source_Code\Ashida_2020_code\invivo")

% access the helper functions from the "Utils" folder 
addpath("..\Utils")

%% 2. Load the preprocessed data from all animals and all cell types
% specify the folder names containing the raw data (here: all)
folders = ["gatorNM", "gatorNL", "chickNM", "chickNL", "owlNM"];

% onset response cutoff [ms]
cutoff = 15;  

% driven spike rate threshold [sp/sec]
R_thresh = 30;  

% threshold for minimum number of spikes
Nsp_thresh = 400;

% preprocessing
[spike_data, Rout] = PreprocessingSpikes(folders, R_thresh, Nsp_thresh, cutoff);


%% 3. Calculate the CI and the VS
% coincidence window [ms] for CI calculation
BW = 0.05;  

% number of bins of the phase histogram for VS calculation
NB = 41;  % Go used NB = 41 (see plotCIvivo.m)

% number of folders
n_folders = length(folders);

% init. output
CI_folder = cell(n_folders, 1); 
VS_folder = cell(n_folders, 1); 

for folder = 1:n_folders
    % data in current folder
    data_folder = getfield(spike_data, folders{folder});
    
    % number of sessions
    n_sessions = size(data_folder, 1);  
    
    % init
    CI_session = zeros(n_sessions, 1);  % CI values
    VS_session = zeros(n_sessions, 1);  % VS values
    
    for session = 1:n_sessions
        % spike trains of current session
        SPin = data_folder{session, 1};
        
        % stimulus specifics of current session
        FQ = data_folder{session, 3};
        durat = data_folder{session, 5};
        delay = data_folder{session, 6};
        cutoff = data_folder{session, 7};
        
        % starting and ending time of stimulus
        T1 = delay + cutoff;  % starting time [ms] for the analysis 
        T2 = delay + durat;  % ending time [ms] for the analysis  
        
        % maximum time difference [ms] for SAC calculation
        TL = durat/5 * (1000/FQ);  
        
        % CI calculation
        [~, ~, CI_session(session), ~, ~] = calcSAC(SPin, BW, T1, T2, TL);
        
        % VS calculation
        [~, ~, VS_session(session)] = calcPhaseHist(SPin, T1, T2, NB, FQ);
    end
    
    % results for current "animal/cell type" folder 
    CI_folder{folder} = CI_session;
    VS_folder{folder} = VS_session;    
end

%% 4. Plot the VS against the CI values
cols = {[0,0.6,0], [0,0.4,0.2], [0.8,0,0], [1,0.6,0], [0,0,0.8]};
symb = ['d', '+', 's', 'x', 'o'];
leg = string();  % init.

% define the theoretical relation line
kappa = 0:0.1:80;
VStheo = besseli(1,kappa) ./ besseli(0,kappa);
CItheo = besseli(0,2*kappa) ./ (besseli(0,kappa)).^2;

figure
for f = 1:n_folders
   leg(f) = folders(f) + " (N=" + string(numel(CI_folder{f})) + ")";
   plot(CI_folder{f},VS_folder{f},symb(f),'color',cols{f})
   hold on
end
plot(CItheo, VStheo, '-k')  % reference line
plot(CItheo*1.4, VStheo, '--', 'color', [0.4, 0.4, 0.4])  % CI = 1.4 * CI_est(VS)
plot(CItheo*0.7, VStheo, '--', 'color', [0.6, 0.6, 0.6])  % CI = 0.7 * CI_est(VS)

% cosmetics
xlabel("CI")
xlim([min(cellfun(@min,CI_folder))-1, max(cellfun(@max, CI_folder))+1])
ylim([0, 1])
xlim([0, 11])
ylabel("VS")
title("VS-CI Comparison (invivo)")
leg(n_folders+1) = 'theo';  % legend extension
leg(n_folders+2) = '1.4*CI_e_s_t(VS)';  % legend extension
leg(n_folders+3) = '0.7*CI_e_s_t(VS)';  % legend extension
legend(leg, 'Location', 'best')
hold off

