%% I. Overview of Data Structure
%  delay --- starting time of sound stimulus 
%  durat --- duration of sound stimulus
%  epoch --- duration of each recording trial 
%  depvar -- stimulus parameter (-6666 indicates spontaneous response = no stimulus)
%  freq ---- stimulus frequency [Hz]
%  spikes -- recorded spike times [ms] 
%  threshold, abi --- (please just ignore them) 

d = load("982.44.5.40.spikes.mat");

%% 1. Load the analysis files from Ashida2020 and Joris2006
% We want to compare the code computing the SAC written by Ashida (2020) 
% with the one written by Joris (2006). For this, we load both directories
% in here and run their functions with invivo data from the folder
% "Raw_Data". We compare Ashida's "calcSAC.m" with Joris' "SPTCORR.m" 
% function.

path = strcat("C:\Users\Dominik\Documents\Uni_Oldenburg\5th_semester\", ...
              "\MasterThesis\3.Matlab\Code_Tests\");
cd(path)

% old code base, access: MetaAnalysis_VS_CI.m
%addpath("C:\Users\Dominik\Documents\Uni_Oldenburg\2nd_semester\2_Research_Module(15ECTS)\Dominik_VSanalysis\data")

% access the repos from Ashida and Joris
FunctionLoader("..\Source_Code\Ashida_2020_code\invivo")
FunctionLoader("..\Source_Code\Joris_2006_code")

% load data
folders = ["chickNL", "chickNM", "gatorNL", "gatorNM", "owlNM"];
raw_data = DataLoader(folders);

a1 = SpikeDataLoader(folders);
% spikes from session s, trial t: a1.chickNL{s}{1}{t}
% depvar from session s, trial t: a1.chickNL{s}{2}{t}
% freq from session s: a1.chickNL{s}{3}
% epoch from session s: a1.chickNL{s}{4}
% durat from session s: a1.chickNL{s}{5}
% delay from session s: a1.chickNL{s}{6}

a2 = RemoveEmptyCells(folders);
% spikes from session s, trial t: a2.chickNL{s}{1}{t}
% depvar from session s, trial t: a2.chickNL{s}{2}{t}
% freq from session s: a2.chickNL{s}{3}
% epoch from session s: a2.chickNL{s}{4}
% durat from session s: a2.chickNL{s}{5}
% delay from session s: a2.chickNL{s}{6}

%% 2. Conduct Analysis
% Our goal is to compare both the CI and the SAC. To compare the CI, we 
% first calculate the SAC and take the value at delay 0. This value will be
% a 'double' and we can easily compare logically. For the SAC, we get need
% to compare the x-values and the y-values. They need to have the same
% amount of points (same coincidence window should lead to same number of 
% points). Only if all points match, we consider the two codes equivalent.

spike_data = RemoveEmptyCells(folders);

% Let's print the data of the first recording of the chicken - NL data
sprintf("class: %s,\nsize: (%d, %d)", class(spike_data.chickNL{1}), ...
    size(spike_data.chickNL{1}))
strtrim(sprintf("One example spike train: [%.3f, %.3f, %.3f]", ...
    spike_data.chickNL{1}{1}{1}))

%% set input parameters for analysis
cutoff = 20;  % onset response cutoff [ms]
BW = 0.05;  % coincidence window [ms]

% number of folders
n_folders = length(folders);

% init - Ashida
SAC_Ashida_folder = cell(n_folders, 1); 
SACtv_Ashida_folder = cell(n_folders, 1); 
CI_Ashida_folder = cell(n_folders, 1); 
Nsp_Ashida_folder = cell(n_folders, 1); 

% init - Joris
H_Joris_folder = cell(n_folders, 1);
BC_Joris_folder = cell(n_folders, 1);
N_Joris_folder = cell(n_folders, 1);
CI_Joris_folder = cell(n_folders, 1);

for folder = 1:n_folders
    % data in current folder
    data_folder = getfield(spike_data, folders(folder));
    n_sessions = length(data_folder);  % number of sessions
    
    % init - Ashida
    SAC_Ashida_session = cell(n_sessions, 1); 
    SACtv_Ashida_session = cell(n_sessions, 1); 
    CI_Ashida_session = cell(n_sessions, 1); 
    Nsp_Ashida_session = cell(n_sessions, 1); 
    
    % init - Joris
    H_Joris_session = cell(n_sessions, 1);
    BC_Joris_session = cell(n_sessions, 1);
    N_Joris_session = cell(n_sessions, 1);
    CI_Joris_session = cell(n_sessions, 1);
    
    for session = 1:n_sessions
        % spike trains of current session
        SPin = data_folder{session}{1};
        
        % stimulus specifics of current session
        freq = data_folder{session}{3};
        durat = data_folder{session}{5};
        delay = data_folder{session}{6};
        
        % starting and ending time of stimulus
        T1 = delay + cutoff;  % starting time [ms] for the analysis 
        T2 = delay + durat;  % ending time [ms] for the analysis  
        TL = durat/2;  % * (1000/freq);  % maximum time difference [ms] for SAC calculation
        
        % Ashida's function
        [SAC_Ashida_session{session}, SACtv_Ashida_session{session}, ...
            CI_Ashida_session{session}, ~, Nsp_Ashida_session{session}] = ...
            calcSAC(SPin, BW, T1, T2, TL);
        
        % before feeding the spike trains to Joris' function, we need to
        % truncate the spike trains from T1 to T2.
        n_trials = length(SPin);
        SP = cell(n_trials, 1);
        for c = 1:n_trials
          v = SPin{c}; 
          SP{c} = v(v>=T1 & v<=T2);  
        end
        
        % Joris' function
        [H_Joris_session{session}, BC_Joris_session{session}, ...
            N_Joris_session{session}] = SPTCORR(SP, 'nodiag', TL, BW, ...
            durat, 'LouageNorm');
        log_idx = BC_Joris{session} == 0;  % logical indexing
        H = H_Joris{session};
        CI_Joris_session{session} = H(log_idx); 
    end
    % folder results Ashida
    SAC_Ashida_folder{folder} = SAC_Ashida_session;
    SACtv_Ashida_folder{folder} = SACtv_Ashida_session; 
    CI_Ashida_folder{folder} = CI_Ashida_session;
    Nsp_Ashida_folder{folder} = Nsp_Ashida_session;  
    
    % folder results Joris
    H_Joris_folder{folder} = H_Joris_session;
    BC_Joris_folder{folder} = BC_Joris_session;
    N_Joris_folder{folder} = N_Joris_session;
    CI_Joris_folder{folder} = CI_Joris_session;
    
end

%% 3. Results (with plots)
% We find that both pieces of code come to the same result. Hence, we
% consider them equivalent.

% plot the CI values against each other (they should form a perfect line)


% plot the SACs of a defined dataset in one figure and look for overlap



