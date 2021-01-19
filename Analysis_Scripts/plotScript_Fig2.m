%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script creates all the figures for the panels A to G of Figure 2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% panel A: Raster plots for simulated spike trains (VSin=0.31/0.61/0.91)

% load the generated data
path_GenData = "..\Gen_Data\Raw_GenData\";
load(path_GenData + "gen_data.mat");  
% this loads the struct "gen_data" with the field "dec6_2020" into the
% workspace. It contains spike and meta data from 46 simulation sweeps with
% different VSin values, spaced from 0.05:0.02:0.95. This is the order of
% the parameters (columnwise):
% 1. spike trains [ms]
% 2. depvar (not needed in this data)
% 3. frequency of stimulation [Hz]
% 4. epoch = duration [ms]
% 5. duration [ms]
% 6. delay = 0 [ms]
% 7. cutoff = 0 [ms]
% 8. spike rate    
% 9. total number of spikes
% 10. VS value which the spike trains are generated from
% 11. concentration parameter vonMises (back-calculated from emp VS)

% Find the indices for the desired data
VSin = [gen_data.dec6_2020{:,10}];
idx031 = find(VSin>0.3 & VSin<0.32);
idx061 = find(VSin>0.6 & VSin<0.62);
idx091 = find(VSin>0.9 & VSin<0.92);

% get the spike trains
spt031 = gen_data.dec6_2020{idx031,1};
spt061 = gen_data.dec6_2020{idx061,1};
spt091 = gen_data.dec6_2020{idx091,1};

% 1st raster plot VSin=0.31
f1 = figure(1);
VSin031 = gen_data.dec6_2020{idx031, 10};
Nsp031 = gen_data.dec6_2020{idx031, 9};
for k=1:51
   plot(spt031{k}, k*ones(1,length(spt031{k})), '.k', 'Markersize', 5)
   hold on
end
title(sprintf("Raster plot - simulated data VS=%.2f, Nsp=%.0f", VSin031, Nsp031))
xlabel("time (ms)")
ylabel("reps")
xlim([-10, 120])  % show trials from 0ms to 120ms
ylim([0, 52])  % 51 (same number as in bad example raster)

% 2nd raster plot VSin=0.61
f2 = figure(2);
VSin061 = gen_data.dec6_2020{idx061, 10};
Nsp061 = gen_data.dec6_2020{idx061, 9};
for k=1:51
   plot(spt061{k}, k*ones(1,length(spt061{k})), '.k', 'Markersize', 5)
   hold on
end
title(sprintf("Raster plot - simulated data VS=%.2f, Nsp=%.0f", VSin061, Nsp061))
xlabel("time (ms)")
ylabel("reps")
xlim([-10, 120])  % show trials from 0ms to 120ms
ylim([0, 52])  % 51 (same number as in bad example raster)

% 3rd raster plot VSin=0.91
f3 = figure(3);
VSin091 = gen_data.dec6_2020{idx091, 10};
Nsp091 = gen_data.dec6_2020{idx091, 9};
for k=1:51
   plot(spt091{k}, k*ones(1,length(spt091{k})), '.k', 'Markersize', 5)
   hold on
end
title(sprintf("Raster plot - simulated data VS=%.2f, Nsp=%.0f", VSin091, Nsp091))
xlabel("time (ms)")
ylabel("reps")
xlim([-10, 120])  % show trials from 0ms to 120ms
ylim([0, 52])  % 51 (same number as in bad example raster)

%% panel B: Phase histograms corresponding to the rasters in panel A
% add path of source code provided by Go Ashida
addpath("..\Source_Code\Ashida_2020_code\invivo\")

% get some of the meta data (same for all 46 sweeps)
durat = gen_data.dec6_2020{1,5};
delay = gen_data.dec6_2020{1,6};
cutoff = gen_data.dec6_2020{1,7};
T1 = delay + cutoff; % start of analysis [ms] 
T2 = delay + durat; % enf of analysis [ms]
NB = 42;  % number of bins used for the histogram
FQ = gen_data.dec6_2020{1,3};  % stimulation frequency

% phase histogram for VSin=0.31
[PH031, PHtv031, VS031] = calcPhaseHist(spt031,T1,T2,NB,FQ);

% change the bins to that the peak is centered in [-0.5, 0.5]
bins031 = [PHtv031(22:end)-1, PHtv031(1:21)];
yy031 = [PH031(22:end), PH031(1:21)];

% plot (VSin=0.31)
f4 = figure(4);
% plot(bins031, yy031, '-k')
p4 = bar(bins031, yy031, 'histc');
set(p4, 'FaceColor', 'k')
set(p4, 'EdgeColor', 'k')
title(sprintf("Phase Histogram - simulated data VSin=%.2f, VSout=%.2f",...
    VSin031, VS031))
xlabel("phase (cycle)")
ylabel("spike rate (Hz)")
xlim([-0.5 0.5])
ylim([0 1800])

% phase histogram for VSin=0.61
[PH061, PHtv061, VS061] = calcPhaseHist(spt061,T1,T2,NB,FQ);

% change the bins to that the peak is centered in [-0.5, 0.5]
bins061 = [PHtv061(22:end)-1, PHtv061(1:21)];
yy061 = [PH061(22:end), PH061(1:21)];

% plot (VSin=0.61)
f5 = figure(5);
% plot(bins061, yy061, '-k')
p5 = bar(bins061, yy061, 'histc');
set(p5, 'FaceColor', 'k')
set(p5, 'EdgeColor', 'k')
title(sprintf("Phase Histogram - simulated data VSin=%.2f, VSout=%.2f", ...
    VSin061, VS061))
xlabel("phase (cycle)")
ylabel("spike rate (Hz)")
xlim([-0.5 0.5])
ylim([0 1800])

% phase histogram for VSin=0.91
[PH091, PHtv091, VS091] = calcPhaseHist(spt091,T1,T2,NB,FQ);

% change the bins to that the peak is centered in [-0.5, 0.5]
bins091 = [PHtv091(22:end)-1, PHtv091(1:21)];
yy091 = [PH091(22:end), PH091(1:21)];

% plot (VSin=0.91)
f6 = figure(6);
% plot(bins091, yy091, '-k')
p6 = bar(bins091, yy091, 'histc');
set(p6, 'FaceColor', 'k')
set(p6, 'EdgeColor', 'k')
title(sprintf("Phase Histogram - simulated data VSin=%.2f, VSout=%.2f", ...
    VSin091, VS091))
xlabel("phase (cycle)")
ylabel("spike rate (Hz)")
xlim([-0.5 0.5])
ylim([0 1800])

%% panel C: VS-kappa curve
kappa = 0:0.1:11;
VStheo = besseli(1,kappa) ./ besseli(0,kappa);
f7 = figure(7);
plot(kappa, VStheo, '-k')
xlabel('concentration parameter kappa')
ylabel('Vector Strength')
title('VS-kappa curve')
set(f7,'Position',[360 198 400 300])

%% panel D: SAC curves corresponding to the rasters in panel A
% add path of source code provided by Go Ashida
addpath("..\Source_Code\Ashida_2020_code\invivo\")

% get some of the meta data (same for all 46 sweeps)
durat = gen_data.dec6_2020{1,5};
delay = gen_data.dec6_2020{1,6};
cutoff = gen_data.dec6_2020{1,7};

% set parameters
BW = 0.05; % coincidence window [ms]
T1 = delay + cutoff; % start of analysis [ms] 
T2 = delay + durat; % enf of analysis [ms]
TL = 6; % max binwidth/delay shown in the SAC

% phase histogram for VSin=0.31
[SAC031, SACtv031, CI031, ~, Nsp031] = calcSAC(spt031, BW, T1, T2, TL);
f8 = figure(8);
plot(SACtv031, SAC031, '-k')
title(sprintf("SAC - simulated data VSin=%.2f, CI=%.2f, Nsp=%.0f", ...
    VSin031, CI031, Nsp031))
xlabel("delay (ms)")
ylabel("norm. coincidences")
ylim([0 4.5])

% phase histogram for VSin=0.61
[SAC061, SACtv061, CI061, ~, Nsp061] = calcSAC(spt061, BW, T1, T2, TL);
f9 = figure(9);
plot(SACtv061, SAC061, '-k')
title(sprintf("SAC - simulated data VSin=%.2f, CI=%.2f, Nsp=%.0f", ...
    VSin061, CI061, Nsp061))
xlabel("delay (ms)")
ylabel("norm. coincidences")
ylim([0 4.5])

% phase histogram for VSin=0.91
[SAC091, SACtv091, CI091, ~, Nsp091] = calcSAC(spt091, BW, T1, T2, TL);
f10 = figure(10);
plot(SACtv091, SAC091, '-k')
title(sprintf("SAC - simulated data VSin=%.2f, CI=%.2f, Nsp=%.0f", ...
    VSin091, CI091, Nsp091))
xlabel("delay (ms)")
ylabel("norm. coincidences")
ylim([0 4.5])

%% panel E: CI-kappa curve
kappa = 0:0.1:11;
CItheo = besseli(0,2*kappa) ./ (besseli(0,kappa)).^2;
f11 = figure(11);
plot(kappa, CItheo, '-k')
xlabel('concentration parameter kappa')
ylabel('Correlation Index')
title('CI-kappa curve')
set(f11,'Position',[360 198 400 300])

%% panel F: VS-CI plot (theoretical)
kappa = 0:0.1:45;
VStheo = besseli(1,kappa) ./ besseli(0,kappa);
CItheo = besseli(0,2*kappa) ./ (besseli(0,kappa)).^2;
f12 = figure(12);
plot(CItheo, VStheo, '-k')
ylabel('Vector Strength')
xlabel('Correlation Index')
title('VS-CI curve')
set(f12,'Position',[360 198 400 300])

%% panel G: Decay of SAC through stimulus duration


