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
              "\MasterThesis\MatlabThesis\Code_Tests\");
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

%% 2. Conduct Analysis
% Our goal is to compare both the CI and the SAC. To compare the CI, we 
% first calculate the SAC and take the value at delay 0. This value will be
% a 'double' and we can easily compare logically. For the SAC, we get need
% to compare the x-values and the y-values. They need to have the same
% amount of points (same coincidence window should lead to same number of 
% points). Only if all points match, we consider the two codes equivalent.

% set input parameters for preprocessing
cutoff = 15;  % onset response cutoff [ms]
R_thresh = 30;  % driven spike rate threshold [sp/sec]

[spike_data, Rout] = PreprocessingSpikes(folders, R_thresh, cutoff);
% spikes from session s, trial t: spike_data.chickNL{s, 1}{t}
% depvar from session s, trial t: spike_data.chickNL{s, 2}{t}
% freq from session s: spike_data.chickNL{s, 3}
% epoch from session s: spike_data.chickNL{s, 4}
% durat from session s: spike_data.chickNL{s, 5}
% delay from session s: spike_data.chickNL{s, 6}
% cutoff from session s: spike_data.chickNL{s, 7}
% driven spike rate from session s: spike_data.chickNL{s, 8}


% Let's print the data of the first recording of the chicken - NL data
sprintf("class: %s,\nsize: (%d, %d)", class(spike_data.chickNL{1}), ...
    size(spike_data.chickNL{1}))
strtrim(sprintf("One example spike train: [%.3f, %.3f, %.3f, %.3f, %.3f, %.3f]", ...
    spike_data.chickNL{1, 1}{2}))

%% set input parameters for analysis
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
    data_folder = getfield(spike_data, folders{folder});
    
    % number of sessions
    n_sessions = length(data_folder);  
    
    % init - Ashida
    SAC_Ashida_session = cell(n_sessions, 1);   % SAC values
    SACtv_Ashida_session = cell(n_sessions, 1); % Bin centers for SAC
    CI_Ashida_session = cell(n_sessions, 1);    % CI values
    Nsp_Ashida_session = cell(n_sessions, 1);   % number of spikes
    
    % init - Joris
    H_Joris_session = cell(n_sessions, 1);      % SAC values
    BC_Joris_session = cell(n_sessions, 1);     % Bin centers for SAC
    CI_Joris_session = cell(n_sessions, 1);     % CI values
    N_Joris_session = cell(n_sessions, 1);      % number of spikes
    
    for session = 1:n_sessions
        % spike trains of current session
        SPin = data_folder{session, 1};
        
        % stimulus specifics of current session
        freq = data_folder{session, 3};
        durat = data_folder{session, 5};
        delay = data_folder{session, 6};
        cutoff = data_folder{session, 7};
        
        % starting and ending time of stimulus
        T1 = delay + cutoff;  % starting time [ms] for the analysis 
        T2 = delay + durat;  % ending time [ms] for the analysis  
        
        % maximum time difference [ms] for SAC calculation
        TL = durat/5 * (1000/freq);  % Go used TL = 6 (see plotCIvivo.m)
        
        % Ashida's function
        [SAC_Ashida_session{session}, SACtv_Ashida_session{session}, ...
            CI_Ashida_session{session}, ~, Nsp_Ashida_session{session}] = ...
            calcSAC(SPin, BW, T1, T2, TL);
        
        % before feeding the spike trains to Joris' function, we need to
        % truncate the spike trains from T1 to T2.
        %n_trials = length(SPin);
        %SP = cell(n_trials, 1);
        %for c = 1:n_trials
        %  v = SPin{c}; 
        %  SP{c} = v(v>=T1 & v<=T2);  
        %end
        
        % Joris' function
        [H_Joris_session{session}, BC_Joris_session{session}, ...
            N_Joris_session{session}] = SPTCORR(SPin, 'nodiag', TL, BW, ...
            durat-cutoff, 'LouageNorm');
        log_idx = BC_Joris_session{session} == 0;  % logical indexing
        H = H_Joris_session{session};
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

%% 3.1 Results (with plots)
% plot the CI values against each other (they should form a perfect line)

figure()
for folder_nr = 1:n_folders
    
    subplot(3,2,folder_nr)
    
    % define x and y values
    xx = cell2mat(CI_Joris_folder{folder_nr});
    yy = cell2mat(CI_Ashida_folder{folder_nr});
    
    % plotting
    plot(xx, yy, 'b+')
    hold on
    ref_low = min([xx, yy]); 
    ref_high = max([xx, yy]);
    plot([ref_low, ref_high], [ref_low, ref_high],'k-')
    hold off
    
    % plotting cosmetics
    legend("empirical results", "reference line", 'Location', 'best')
    ylabel("CI Ashida")
    xlabel("CI Joris")
    title(sprintf("data:%s", folders(folder_nr)))
end
suptitle("Comparison of CI values")

%% 3.2 Results (with plots)
% plot the SACs of a defined dataset in one figure and look for overlap
figure()
session_nr = 1;
%folder_nr = 2;  % gator NL
plot(BC_Joris_folder{folder_nr}{session_nr}, ...
    H_Joris_folder{folder_nr}{session_nr}, 'b')
hold on
plot(SACtv_Ashida_folder{folder_nr}{session_nr}, ...
    SAC_Ashida_folder{folder_nr}{session_nr}, 'r')
hold off
% plotting cosmetics
legend("Joris", "Ashida")
ylabel("normalized coincidences")
xlabel("delay [ms]")
title(sprintf("SAC - data:%s, session:%d", folders(folder_nr), session_nr))

%% 3.3 Results (with plots)
% compare the number of spikes going into the calculation.

figure()
for folder_nr = 1:n_folders
    
    subplot(3,2,folder_nr)
    
    % define x and y values for plotting
    
    % Joris
    Nsess = length(N_Joris_folder{folder_nr});
    xx = zeros(Nsess, 1);
    for s = 1:Nsess
        xx(s) = N_Joris_folder{folder_nr}{s}.Nspike1;
    end
    
    % Ashida
    yy = cell2mat(Nsp_Ashida_folder{folder_nr});
    
    % plotting
    plot(xx, yy, 'b+')
    hold on
    ref_low = min([xx, yy]); 
    ref_high = max([xx, yy]);
    plot([ref_low, ref_high], [ref_low, ref_high],'k-')
    hold off
    
    % plotting cosmetics
    legend("empirical results", "reference line", 'Location', 'best')
    ylabel("CI Ashida")
    xlabel("CI Joris")
    title(sprintf("data:%s", folders(folder_nr)))
end
suptitle("Comparison of spike numbers")

%% 4. Conclusion

% By qualitative assessment, we find that both pieces of code come to the
% same result. Hence, we consider them equivalent.