%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code produces the figures needed for Figure 1A, 1C and 1E of the
% paper, i.e. raster plots, period histograms and SAC curves for one "good"
% unit (namely gatorNL 05.13.3 and/or gatorNL 05.07.4) of the invivo data 
% stored in "../Raw_Data/gatorNL/".
% Additionally, the script calculates the three plots for one "bad" unit
% of the same data set, namely gatorNL 10.07.11, which is used in Fig 4A-C.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler, Jan 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Path management
% set current directory
path = strcat("C:\Users\Dominik\Documents\Uni_Oldenburg\5th_semester\", ...
              "\MasterThesis\MatlabThesis\Analysis_Scripts\");
cd(path)

% access the repo from Ashida for calcSAC.m and calcPhaseHist.m
addpath("../Source_Code/Ashida_2020_code/invivo")

% set data path
path_data = "../Raw_Data/gatorNL/";

% set cutoff
cutoff = 15;  % in [ms]

%% Some Preprocessing and Data Analysis - good example unit
filename_good = "05.07.4.spikes.mat";  % ARO: "05.13.3.spikes.mat";  
data_good = load(path_data + filename_good); 
spt_raw = data_good.spikes;
depvar = data_good.depvar;
durat1 = data_good.durat;  % stimulus duration
delay1 = data_good.delay;  % start of stimulation
Nrep_good = numel(spt_raw);  % number of repetitions

% truncation window 
T1_good = delay1 + cutoff;  % start of stimulation [ms]
T2_good = delay1 + durat1;  % end of stimulation [ms]

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
f1 = figure(1);
for k = 1:51  % don't use numel(spt_stim_good)
    plot(spt_stim_good{k} - delay1, k*ones(1,length(spt_stim_good{k})), ...
        '.k', 'MarkerSize', 5)
    hold on
end
hold off
xlabel('time (ms)')
ylabel('repetition')
title(sprintf('Raster Plot - Gator NL %s', filename_good))
xlim([-5, 45])  % Frontiers
% xlim([-10, 120])  % ARO: show trials from -10ms to 120ms
ylim([0, 52])  % 51 (same number as in bad example raster)

f1.Position = [100 100 540 400];  % set the figure size

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
f2 = figure(2);
for k = 1:numel(spt_stim_bad)
    plot(spt_stim_bad{k} - delay, k*ones(1,length(spt_stim_bad{k})), '.k', ...
        'MarkerSize', 5)
    hold on
end
hold off
xlabel('time (ms)')
ylabel('repetition')
title(sprintf('Raster Plot - Gator NL %s', filename_bad))
xlim([-5, 45])  % manuscript version
% xlim([-10, 120])  % ARO version: show trials from -10ms to 120ms
ylim([0, 52])  % 51 (same number as in bad example raster)

f2.Position = [100 100 540 400];  % set the figure size

%% Period Histogram - good example
NB = 51;
FQ_good = data_good.freq;  % frequency [Hz]
[PH_good, PHtv_good, VS_good] = calcPhaseHist(spt_stim_good, T1_good, ...
                                    T2_good, NB, FQ_good);  
                                
% plot
f3 = figure(3);
% plot(PHtv_good, PH_good)
p3 = bar(PHtv_good, PH_good, 'histc');
set(p3, 'FaceColor', 'k')
set(p3, 'EdgeColor', 'k') 
title(sprintf("Phase Histogram - Gator NL %s, VS=%.2f, FQ=%d Hz", ...
        filename_good, VS_good, FQ_good))
xlabel("phase (cycle)")
ylabel("spike rate [Hz]")
ylim([0 100])
% ARO: ylim([0 165])

f3.Position = [100 100 540 400];  % set the figure size

%% Period Histogram - bad example
NB = 51;  % should match NB above
FQ_bad = data_bad.freq;  % frequency [Hz]
[PH_bad, PHtv_bad, VS_bad] = calcPhaseHist(spt_stim_bad, T1_bad, ...
                                T2_bad, NB, FQ_bad);

% plot
f4 = figure(4);
% plot(PHtv_bad, PH_bad)
p4 = bar(PHtv_bad, PH_bad, 'histc');
set(p4, 'FaceColor', 'k')
set(p4, 'EdgeColor', 'k') 
title(sprintf("Phase Histogram - Gator NL %s, VS=%.2f, FQ=%d Hz", ...
        filename_bad, VS_bad, FQ_bad))
xlabel("phase (cycle)")
ylabel("spike rate [Hz]")
ylim([0 60])

f4.Position = [100 100 540 400];  % set the figure size

%% SAC curve - good example
BW = 0.05;  % coincidence window in [ms]
TL = 6;  % max histogram bin
[SAC_good, SACtv_good, CI_good, ~, ~] = calcSAC(spt_stim_good, BW, ...
                                            T1_good, T2_good, TL); 

% plot
f5 = figure(5);
plot(SACtv_good, SAC_good, '-k')
title(sprintf("SAC - Gator NL %s, VS=%.2f, CI=%.2f", filename_good, ...
    VS_good, CI_good))
xlabel("delay (ms)")
ylabel("norm. coincidences")
ylim([0 3])
% ARO: ylim([0 4.5])

f5.Position = [100 100 540 400];  % set the figure size

%% SAC curve - bad example
BW = 0.05;  % coincidence window in [ms]
TL = 9;  % max histogram bin
[SAC_bad, SACtv_bad, CI_bad, ~, ~] = calcSAC(spt_stim_bad, BW, T1_bad, ...
                                        T2_bad, TL);

% plot
f6 = figure(6);
plot(SACtv_bad, SAC_bad, '-k')
title(sprintf("SAC - Gator NL %s, VS=%.2f, CI=%.2f", filename_bad, ...
    VS_bad, CI_bad))
xlabel("delay (ms)")
ylabel("norm. coincidences")
ylim([0 4])
% ylim([0 4.5])  % ARO poster version 
xlim([-9 9])

f6.Position = [100 100 540 400];  % set the figure size
