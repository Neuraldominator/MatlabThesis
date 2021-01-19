%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code produces the figures needed for Figure 4D-I of the paper, i.e.
% raster plots, period histograms and SAC curves for two simulated units of
% the ANmodel with skewed / bimodal spiking distributions, namely
% GBC200Hz40db and AN200Hz70db.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler, Jan 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load the data files
path1 = "../Source_Code/ANmodel/GBCdata/";
filename1 = "GBC200Hz40dB";
path2 = "../Source_Code/ANmodel/ANdata/ANdata0/";
filename2 = "AN200Hz70dB";
GBC = load(path1 + filename1 + "4SAC.mat");
AN = load(path2 + filename2 + "4SAC.mat");

% addpaths
addpath("../Source_Code/Ashida_2020_code/invivo")

%% Set parameters for later analyses
% retrieve some relevant parameters from "..\Source_Code\ANmodel\trainAN.m"
dt = 0.01; % [ms] time step -- 100kHz sampling rate
epoch = 200;  % duration [ms] of entire simulation
delay = 25;  % [ms] start of stimulus (5ms ramping)

% set the start T1 and end T2 of the analysis window
cutoff = 15;  % onset response cutoff in [ms]
T1 = delay + cutoff;
T2 = epoch;  % stimulus goes until very end of simulation

% function inputs for calcPhaseHist.m and calcSAC.m
BW = 0.05;  % coincidence window for SAC [ms]
TL = 12;  % max histogram bin for SAC
NB = 41;  % number of bins for phase histogram

Nrep = 51;  % number of reps displayed in the raster (cf. Fig 1)
M = 400;  % number of spike trains being used for phase histogram and SAC

%% panel D: Raster plot GBC
% convert binary spikes into spike times with temp. resolution dt=0.01
sptGBC = cell(1, 400);
for k = 1:400
   sptGBC{k} = find(GBC.BCout(k,:)==1) * dt;  % spike times in [ms]
end

% plot raster
f1 = figure(1);
for k = 1:Nrep  % stimulation start = 0ms
   plot(sptGBC{k} - delay, k*ones(1,length(sptGBC{k})), 'k.', 'MarkerSize', 5)
   hold on
end
xlabel('time (ms)')
ylabel('repetition')
title(sprintf('Raster Plot - %s', filename1))
xlim([-25, 120])  % show trials from -25ms to 120ms
ylim([0, 52])  % 51 (same number as in bad example raster)

%% panel G: Raster plot AN
% convert binary spikes into spike times with temp. resolution dt=0.01
sptAN = cell(1, 400);
for k = 1:400
   sptAN{k} = find(AN.ANout(k,:)==1) * dt;  % spike times in [ms]
end

% plot raster
f2 = figure(2);
for k = 1:Nrep  % stimulation start = 0ms
   plot(sptAN{k} - delay, k*ones(1,length(sptAN{k})), 'k.', 'MarkerSize', 5)
   hold on
end
xlabel('time (ms)')
ylabel('repetition')
title(sprintf('Raster Plot - %s', filename2))
xlim([-25, 120])  % show trials from -25ms to 120ms
ylim([0, 52])  % 51 (same number as in bad example raster)

%% panel E: Phase Histogram GBC
FQ = 200;  % stimulation frequency [Hz]
[PH_GBC, PHtv_GBC, VS_GBC] = calcPhaseHist(sptGBC, T1, T2, NB, FQ);

% rearrange the histogram to cycle [-0.5 0.5]
mid = ceil(NB/2); 
xx_GBC = [PHtv_GBC(mid+1:end)-1, PHtv_GBC(1:mid)];
yy_GBC = [PH_GBC(mid+1:end), PH_GBC(1:mid)];

% plot
f3 = figure(3);
% plot(PHtv_GBC, PH_GBC, 'k-')  % uncentered
% bar(PHtv_GBC, PH_GBC)  % uncentered
% plot(xx_GBC, yy_GBC, 'k-')  % centered
p3 = bar(xx_GBC, yy_GBC, 'histc');  % centered
set(p3, 'FaceColor', 'k')
set(p3, 'EdgeColor', 'k') 
title(sprintf("Phase Histogram - %s, VS=%.2f", filename1, VS_GBC))
xlabel("phase (cycle)")
ylabel("spike rate [Hz]")
if NB==51
   ylim([0 1600])  % for NB=51
elseif NB==41
   ylim([0 1800])  % for NB=41
end
xlim([-0.5 0.5])

%% panel H: Phase Histogram AN
FQ = 200;  % stimulation frequency [Hz]
[PH_AN, PHtv_AN, VS_AN] = calcPhaseHist(sptAN, T1, T2, NB, FQ);

% rearrange the histogram to cycle [-0.5 0.5]
xx_AN = [PHtv_AN(mid+1:end)-1, PHtv_AN(1:mid)];
yy_AN = [PH_AN(mid+1:end), PH_AN(1:mid)];

% plot
f4 = figure(4);
% plot(PHtv_AN, PH_AN, 'k-')  % uncentered
% bar(PHtv_AN, PH_AN)  % uncentered
%plot(xx_AN, yy_AN, 'k-')  % centered
p4 = bar(xx_AN, yy_AN, 'histc');  % centered
set(p4, 'FaceColor', 'k')
set(p4, 'EdgeColor', 'k') 
title(sprintf("Phase Histogram - %s, VS=%.2f", filename2, VS_AN))
xlabel("phase (cycle)")
ylabel("spike rate [Hz]")
if NB==51
   ylim([0 1600])  % for NB=51
elseif NB==41 
   ylim([0 1800])  % for NB=41
end
xlim([-0.5 0.5])

%% panel F: SAC GBC
[SAC_GBC, SACtv_GBC, CI_GBC, ~, ~] = calcSAC(sptGBC, BW, T1, T2, TL);

% plot
f5 = figure(5);
plot(SACtv_GBC, SAC_GBC, '-k')
% bar(SACtv_GBC, SAC_GBC)
title(sprintf("SAC - %s, VS=%.2f, CI=%.2f", filename1, VS_GBC, CI_GBC))
xlabel("delay (ms)")
ylabel("norm. coincidences")
ylim([0 4.5])
xlim([-TL TL])


%% panel I: SAC AN
[SAC_AN, SACtv_AN, CI_AN, ~, ~] = calcSAC(sptAN, BW, T1, T2, TL);

% plot
f6 = figure(6);
plot(SACtv_AN, SAC_AN, '-k')
% bar(SACtv_AN, SAC_AN)
title(sprintf("SAC - %s, VS=%.2f, CI=%.2f", filename2, VS_AN, CI_AN))
xlabel("delay (ms)")
ylabel("norm. coincidences")
ylim([0 4.5])
xlim([-TL TL])
