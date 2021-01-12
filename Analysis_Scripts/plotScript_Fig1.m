%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code produces all the figures needed for Figure 1 of the paper, i.e.
% raster plots, period histograms and SAC curves for one "good" and one
% "bad" unit of the invivo data stored in "../Raw_Data/gatorNL/".
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

%% Raster Plot - good example
filename_good = "05.13.3.spikes.mat";
data_good = load(path_data + filename_good); 
spt_raw = data_good.spikes;
depvar = data_good.depvar;
Nrep = numel(spt_raw);  % number of repetitions

% Removing Spike Doublets (note: the spike detection algorithm sometimes
% detects two (or more) events for each spike -> only use the last one as
% the correct spike
trefract = 0.5;   % refractory window for rejecting double spikes
spt = cell(Nrep, 1);  % init
for n = 1:Nrep
 Nsp = length(spt_raw{n});     
 sptrev = fliplr(spt_raw{n});  
 sptdummy = [max(sptrev) + trefract, sptrev(1:Nsp-1)] ;
 sptrev = sptrev((sptdummy - sptrev) >= trefract);  % remove doublets
 spt{n} = fliplr(sptrev);
end

% plot
figure
for k = 1:Nrep
    plot(spt{k}, k*ones(1,length(spt{k})) , '.k', 'MarkerSize', 5)
    hold on
end
hold off
xlabel('time (ms)')
ylabel('repetition')
title(sprintf('Raster Plot - Gator NL %s', filename_good))

%% Raster Plot - bad example
filename_bad = "10.07.11.spikes.mat";
data_bad = load(path_data + filename_bad); 
spt_raw = data_bad.spikes;
depvar = data_bad.depvar;
Nrep = numel(spt_raw);  % number of repetitions

% removing doublets
trefract = 0.5;   % refractory window for rejecting double spikes
spt = cell(Nrep, 1);  % init
for n = 1:Nrep
 Nsp = length(spt_raw{n});     
 sptrev = fliplr(spt_raw{n});  
 sptdummy = [max(sptrev) + trefract, sptrev(1:Nsp-1)] ;
 sptrev = sptrev((sptdummy - sptrev) >= trefract); 
 spt{n} = fliplr(sptrev);
end

% plot
figure
Nrep = numel(spt);
for k = 1:Nrep
    plot(spt{k}, k*ones(1,length(spt{k})) , '.k', 'MarkerSize', 5)
    hold on
end
hold off
xlabel('time (ms)')
ylabel('repetition')
title(sprintf('Raster Plot - Gator NL %s', filename_bad))

%% Period Histogram - good example
%[PH, PHtv, VS] = calcPhaseHist(SPin, T1, T2, NB, FQ);

%% Period Histogram - bad example


%% SAC 


