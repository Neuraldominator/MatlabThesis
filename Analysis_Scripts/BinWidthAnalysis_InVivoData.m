%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script compares the CI for different bin width values W for the in
% vivo data. The sampling rate was 48077Hz. This means the time step is
% dt=20.8us. The robustness of the CI calculation is then analysed 
% quantitatively.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% I. Calculating CI for each bin width and each unit

% add paths for Preprocessing and CI calculation
addpath("..\Utils")
addpath("..\Source_Code\Ashida_2020_code\invivo")

% load and preprocess the invivo data
folders    = ["gatorNM", "gatorNL", "chickNM", "chickNL", "owlNM"];
R_thresh   = 30;   % minimal spike rate [spikes/s]
Nsp_thresh = 400;  % minimal amount of spikes 
cutoff     = 15;   % in [ms]
TL         = 6;    % unnecessay parameter used in calcSAC below
[data, ~]  = PreprocessingSpikes(folders, R_thresh, Nsp_thresh, cutoff);
datacell2  = struct2cell(data);
datacell   = vertcat(datacell2{1}, datacell2{2}, datacell2{3}, ...
                datacell2{4}, datacell2{5});
Nunits     = size(datacell,1);
            
% define the win width values
W = (40:2:100)./1000;  % in [ms]
Nruns = length(W);

% calculate CI for different W and units
CI = zeros(Nruns, Nunits);
for kn = 1:Nunits
  for kw = 1:Nruns
    T1 = datacell{kn,6} + datacell{kn,7};
    T2 = datacell{kn,6} + datacell{kn,5};
    SPin = datacell{kn,1};
    [~, ~, CI(kw, kn), ~, ~] = calcSAC(SPin, W(kw), T1, T2, TL);
  end
end

%% II. Analysis of robustness
% for each unit, calculate mean and std
meanCI = zeros(1, Nunits);
stdCI = zeros(1, Nunits);
CV_CI = zeros(1, Nunits);

figure
plot(W*1000, CI(:,4))  % plot some arbitrary unit
xlabel("Bin Width W [us]")
ylabel("CI value")

for kn = 1:Nunits
  meanCI(kn) = mean(CI(:,kn));  % mean
  stdCI(kn) = std(CI(:,kn)); % standard deviation
  CV_CI(kn) = stdCI(kn) ./ meanCI(kn);  % coefficient of variation
end

figure
bar(CV_CI)
xlabel("unit number")
ylabel("sd/mean")
ylim([0, 0.25])
xlim([0, 126])


%% III. Identify the high CV units
idx = find(CV_CI > 0.15);

order_of_owldata = ["006.05.7.60.spikes.mat","006.07.7.60.spikes.mat",...
                    "006.08.5.40.spikes.mat","123.22.4.70.spikes.mat",...
                    "123.24.2.50.spikes.mat","123.26.4.50.spikes.mat",...
                    "123.28.7.50.spikes.mat","123.32.4.60.spikes.mat",...
                    "128.04.4.70.spikes.mat","143.08.4.60.spikes.mat",...
                    "146.07.4.40.spikes.mat","146.09.2.40.spikes.mat",...
                    "146.10.2.40.spikes.mat","146.12.2.40.spikes.mat",...
                    "146.14.3.40.spikes.mat","146.16.4.40.spikes.mat",...
                    "146.17.3.40.spikes.mat","146.18.2.40.spikes.mat",...
                    "146.19.2.40.spikes.mat","146.20.2.40.spikes.mat",...
                    "146.21.2.40.spikes.mat","146.22.2.40.spikes.mat",...
                    "146.23.3.40.spikes.mat","146.24.5.60.spikes.mat",...
                    "150.02.3.40.spikes.mat","150.03.3.40.spikes.mat",...
                    "150.04.3.40.spikes.mat","150.05.2.40.spikes.mat",...
                    "150.06.2.40.spikes.mat","155.02.3.60.spikes.mat",...
                    "155.16.9.40.spikes.mat","155.20.2.60.spikes.mat",...
                    "155.21.2.60.spikes.mat","169.04.6.40.spikes.mat",...
                    "169.05.5.40.spikes.mat","169.06.5.40.spikes.mat",...
                    "169.07.5.40.spikes.mat","169.08.5.40.spikes.mat",...
                    "169.10.5.40.spikes.mat","169.11.6.40.spikes.mat",...
                    "169.12.5.40.spikes.mat","169.13.5.40.spikes.mat",...
                    "982.38.9.40.spikes.mat","982.39.11.40.spikes.mat",...
                    "982.39.19.40.spikes.mat","982.40.10.40.spikes.mat",...
                    "982.41.9.40.spikes.mat","982.42.5.40.spikes.mat",...
                    "982.43.3.40.spikes.mat","982.44.5.40.spikes.mat",...
                    "982.45.5.40.spikes.mat"];

units = [];                
for k=1:length(idx)
    units = [units, order_of_owldata(idx(k)-74)];
end
