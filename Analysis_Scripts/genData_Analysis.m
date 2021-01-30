%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script calculates VS and CI for the artifical spike trains generated
% in the script "generateData.m", saved in the folder 
% "..\Gen_Data\Raw_GenData". The VS-CI curve is constructed for this data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1. Load the generated data
load("..\Gen_Data\Raw_GenData\gen_data.mat");

pwd
%% 2. Add path of source code for VS and CI computation
addpath("..\Source_Code\Ashida_2020_code\invivo");
% help calcPhaseHist
% help calcSAC

%% 3. Calculate VS and CIgen_data
% number of cells for loop over
N = size(gen_data.dec6_2020, 1);

% set parameters for the "VS and CI computation" functions
NB = 41;  % number of bins for phase histogram (irrelevant for VS calc.)
BW = 0.05; % coincidence window [ms]

% init.
VS = zeros(N, 1);
CI = zeros(N, 1);
for k = 1:N
  SPin = gen_data.dec6_2020{k, 1};  % spike train
  FQ = gen_data.dec6_2020{k, 3};  % freq
  
  % start and end of analysis window
  T1 = gen_data.dec6_2020{k, 6} + gen_data.dec6_2020{k, 7};  % delay + cutoff
  T2 = gen_data.dec6_2020{k, 6} + gen_data.dec6_2020{k, 5};  % delay + durat
    
  [~, ~, VS(k)] = calcPhaseHist(SPin, T1, T2, NB, FQ);
  
  TL = gen_data.dec6_2020{k, 5}/5 * (1000/FQ);  % max binwidth (irrelevant for CI calc.)
  [~, ~, CI(k), ~, ~] = calcSAC(SPin, BW, T1, T2, TL);
end

%% 4. Plot VS against CI
kappa = 0:0.1:60;
VStheo = besseli(1,kappa) ./ besseli(0,kappa);
CItheo = besseli(0,2*kappa) ./ (besseli(0,kappa)).^2;

f1 = figure;
plot(CI, VS, '+b')
hold on
plot(CItheo, VStheo, '-k') % reference line
hold off

% plot cosmetics
title("Relation between VS and CI based on generated data")
xlabel("CI")
ylabel("VS")
ylim([0, 1])
xlim([0, 11])
legend("generated data", "theoretical line", "Location", "southeast")
set(f1,'Position',[360 198 726 350])

%% compare VSin with empirical VS values 

for k=1:N
    VSin(k) = gen_data.dec6_2020{k, 10};
end

% mean squared error
diff = VS - VSin';
mse = mean(diff.^2);

% summary plot
figure
plot(VSin, VS, 'o')
title(sprintf("Compare input VS with output VS, mse=%.e", mse))
ylabel("VSout")
xlabel("VSin")
xlim([0 1])
ylim([0 1])

