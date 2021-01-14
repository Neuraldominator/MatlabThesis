%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code produces all the figures needed for Figure 1 of the paper, i.e.
% raster plots, period histograms and SAC curves for one "good" and one
% "bad" unit of the invivo data stored in "../Raw_Data/gatorNL/". More
% specifically, the raw figures for panel A, C and E are generated here. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler, Jan 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Path management
% set current directory
path = strcat("C:\Users\Dominik\Documents\Uni_Oldenburg\5th_semester\", ...
              "\MasterThesis\MatlabThesis\Analysis_Scripts\");
cd(path)

% access the repo from Ashida for calcSAC.m and calcPhaseHist.m
addpath("..\Source_Code\Ashida_2020_code\invivo")

% set data path
path_data = "../Raw_Data/gatorNL/";

% set cutoff
cutoff = 15;  % in [ms]

%% Some Preprocessing and Data Analysis - good example unit
filename_good = "05.13.3.spikes.mat";
data_good = load(path_data + filename_good); 
spt_raw = data_good.spikes;
depvar = data_good.depvar;
durat = data_good.durat;  % stimulus duration
delay = data_good.delay;  % start of stimulation
Nrep_good = numel(spt_raw);  % number of repetitions

% truncation window 
T1_good = delay + cutoff;  % start of stimulation [ms]
T2_good = delay + durat;  % end of stimulation [ms]

% refractory window for rejecting double spikes
trefract = 0.5;   

spt_good = cell(Nrep_good, 1);  % init
spt_trunc_good = cell(Nrep_good, 1);  % init
for n = 1:Nrep_good
   % Removing Spike Doublets 
   Nsp = length(spt_raw{n});     
   sptrev = fliplr(spt_raw{n});  
   sptdummy = [max(sptrev) + trefract, sptrev(1:Nsp-1)] ;
   sptrev = sptrev((sptdummy - sptrev) >= trefract);  % remove doublets (take last spike)
   spt_good{n} = fliplr(sptrev);
 
   % truncation 
   temp = spt_good{n};
   spt_trunc_good{n} = temp(temp >= T1_good & temp <= T2_good);
end

% check if driven spike rate >= 30 and if Nsp >= 400 (after truncation)
spt_trunc_stim_good = spt_trunc_good(depvar ~= -6666); 
Nrep_stim_good = numel(spt_trunc_stim_good);
Nsp_good = sum(cellfun(@numel, spt_trunc_stim_good));
D_good = (T2_good - T1_good) / 1000;  % duration of truncation window [s]
R_driven_good = Nsp_good / (D_good * Nrep_stim_good);
if R_driven_good >= 30 && Nsp_good >= 400
    sprintf("the unit %s fulfils the requirements.", filename_good)
else
    sprintf("the unit %s does not fulfil the requirements.", filename_good)
end

% remove all spontaneous trials
spt_stim_good = spt_good(depvar ~= -6666);

%% Raster Plot - good example unit
figure
for k = 1:numel(spt_stim_good)
    plot(spt_stim_good{k}, k*ones(1,length(spt_stim_good{k})), '.k', ...
        'MarkerSize', 5)
    hold on
end
hold off
xlabel('time (ms)')
ylabel('repetition')
title(sprintf('Raster Plot - Gator NL %s', filename_good))
xlim([-0.5, 120])  % show trials from 0ms to 120ms
ylim([0, 51.5])  % 51 (same number as in bad example raster)

%% Some Preprocessing and Data Analysis - bad example unit
filename_bad = "10.07.11.spikes.mat";
data_bad = load(path_data + filename_bad); 
spt_raw = data_bad.spikes;
depvar = data_bad.depvar;
durat = data_bad.durat;  % stimulus duration
delay = data_bad.delay;  % start of stimulation
Nrep_bad = numel(spt_raw);  % number of repetitions

% truncation window
T1_bad = delay + cutoff;  % start of stimulation [ms]
T2_bad = delay + durat;  % end of stimulation [ms]

% refractory window for rejecting double spikes
trefract = 0.5;  % in [ms]

spt_bad = cell(Nrep_bad, 1);  % init
spt_trunc_bad = cell(Nrep_bad, 1);  % init
for n = 1:Nrep_bad
   % Removing Spike Doublets 
   Nsp = length(spt_raw{n});     
   sptrev = fliplr(spt_raw{n});  
   sptdummy = [max(sptrev) + trefract, sptrev(1:Nsp-1)] ;
   sptrev = sptrev((sptdummy - sptrev) >= trefract);  % remove doublets (take last spike)
   spt_bad{n} = fliplr(sptrev);
 
   % truncation 
   temp = spt_bad{n};
   spt_trunc_bad{n} = temp(temp >= T1_bad & temp <= T2_bad);
end

% check if driven spike rate >= 30 and if Nsp >= 400 (after truncation)
spt_trunc_stim_bad = spt_trunc_bad(depvar ~= -6666); 
Nrep_stim_bad = numel(spt_trunc_stim_bad);
Nsp_bad = sum(cellfun(@numel, spt_trunc_stim_bad));
D_bad = (T2_bad - T1_bad) / 1000;  % duration of truncation window [s]
R_driven_bad = Nsp_bad / (D_bad * Nrep_stim_bad);
if R_driven_bad >= 30 && Nsp_bad >= 400
    sprintf("the unit %s fulfils the requirements.", filename_bad)
else
    sprintf("the unit %s does not fulfil the requirements.", filename_bad)    
end

% remove all spontaneous trials
spt_stim_bad = spt_bad(depvar ~= -6666);

%% Raster Plot - bad example unit
figure
for k = 1:numel(spt_stim_bad)
    plot(spt_stim_bad{k}, k*ones(1,length(spt_stim_bad{k})), '.k', ...
        'MarkerSize', 5)
    hold on
end
hold off
xlabel('time (ms)')
ylabel('repetition')
title(sprintf('Raster Plot - Gator NL %s', filename_bad))
xlim([-0.5, 120])  % show trials from 0ms to 120ms
ylim([0, 51.5])  % 51 (same number as in bad example raster)

%% Period Histogram - good example
NB = 41;
FQ_good = data_good.freq;  % frequency [Hz]
[PH_good, PHtv_good, VS_good] = calcPhaseHist(spt_stim_good, T1_good, ...
                                    T2_good, NB, FQ_good);  
                                
% plot
figure
plot(PHtv_good, PH_good)
title(sprintf("Phase Histogram - Gator NL %s, VS=%.2f, FQ=%d Hz", ...
        filename_good, VS_good, FQ_good))
xlabel("phase (cycle)")
ylabel("spike rate [Hz]")

%% Period Histogram - bad example
NB = 41;
FQ_bad = data_bad.freq;  % frequency [Hz]
[PH_bad, PHtv_bad, VS_bad] = calcPhaseHist(spt_stim_bad, T1_bad, ...
                                T2_bad, NB, FQ_bad);

% plot
figure
plot(PHtv_bad, PH_bad)
title(sprintf("Phase Histogram - Gator NL %s, VS=%.2f, FQ=%d Hz", ...
        filename_bad, VS_bad, FQ_bad))
xlabel("phase (cycle)")
ylabel("spike rate [Hz]")

%% SAC curve - good example
BW = 0.05;  % coincidence window in [ms]
TL = 6;  % max histogram bin
[SAC_good, SACtv_good, CI_good, ~, ~] = calcSAC(spt_stim_good, BW, ...
                                            T1_good, T2_good, TL); 

% plot
figure
plot(SACtv_good, SAC_good, '-k')
title(sprintf("SAC - Gator NL %s, VS=%.2f, CI=%.2f", filename_good, ...
    VS_good, CI_good))
xlabel("delay (ms)")
ylabel("norm. coincidences")


%% SAC curve - bad example
BW = 0.05;  % coincidence window in [ms]
TL = 6;  % max histogram bin
[SAC_bad, SACtv_bad, CI_bad, ~, ~] = calcSAC(spt_stim_bad, BW, T1_bad, ...
                                        T2_bad, TL);

% plot
figure
plot(SACtv_bad, SAC_bad, '-k')
title(sprintf("SAC - Gator NL %s, VS=%.2f, CI=%.2f", filename_bad, ...
    VS_bad, CI_bad))
xlabel("delay (ms)")
ylabel("norm. coincidences")
