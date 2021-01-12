%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the amount of deviation between the theoretical and ANmodel 
% data (without AM data) VS and CI values. This is done in two ways:
% (A) "the difference of the theo and sim VS values for the same CI 
%     (= deviation along the y-axis)" and 
% (B) "the difference of the theo and sim CI values for the same VS 
%     (= deviation along the x-axis)" 
% This script loads the data saved in VSCI_ANmodel_AM.mat, which was saved
% in the script "ANmodel_AM_restructure.m".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load VS and CI values from ANmod data (contains the struct variable VSCI)
load("VSCI_ANmodel_AM.mat");

% convert struct to cell array and to matrix
VSCIcell = struct2cell(VSCI);
VSCImat = cell2mat(VSCIcell);
 
% VS values
VSemp = VSCImat(:,1);

% CI values
CIemp = VSCImat(:,2); 

%% Concentration parameter for von Mises distribution
Ndata = length(VSemp);

VStheo = zeros(Ndata, 1);
CItheo = zeros(Ndata, 1);
Kvs = zeros(Ndata, 1);
Kci = zeros(Ndata, 1);
for k = 1:Ndata
    % go from VS to estimated CI
    vsfun = @(K)(besseli(1,K) ./ besseli(0,K) - VSemp(k));
    Kvs(k) = fsolve(vsfun, 1.0, optimset('Display','off'));
    CItheo(k) = besseli(0,2*Kvs(k)) ./ (besseli(0,Kvs(k))^2);

    % go from CI to estimated VS
    cifun = @(K)(besseli(0,2*K) ./ besseli(0,K)^2 - CIemp(k));
    Kci(k) = fsolve(cifun, 1.0, optimset('Display','off'));
    VStheo(k) = besseli(1,Kci(k)) ./ besseli(0,Kci(k));

end

%% Calculate Errors 
VS_error = (VSemp - VStheo) ./ VStheo;
CI_error = (CIemp - CItheo) ./ CItheo;

%% Plot results
bin_width = 1;
edges = -80.5:bin_width:80.5;  

figure
subplot(1,2,1)
histogram(100*VS_error, edges, "FaceColor", 'blue', "FaceAlpha", 1)
hold on
histogram(100*VS_error(VSemp < 0.1), edges, "FaceColor", 'red', ...
    "FaceAlpha", 1)  % "EdgeColor", 'none'
hold off
title("VS Error: (VSemp-VStheo)/VStheo")
ylim([0,5])
xlabel("rel. error [%]")
ylabel("counts")
legend('VS >= 0.1', 'VS < 0.1', 'Location', 'northeast')

subplot(1,2,2)
histogram(100*CI_error, edges, "FaceColor", 'b', "FaceAlpha", 1)
%hold on
%histogram(100*CI_error(CIemp < 1), edges, "FaceColor", 'r')
%alpha(1)
%hold off
title("CI Error: (CIemp-CItheo)/CItheo")
xlabel("rel. error [%]")
ylabel("counts")
%legend('CI >= 1', 'CI < 1', 'Location', 'northeast')


%% Identify the outliers
% load preprocessed data
addpath("..\Utils\")  % add helper functions
path = "..\Source_Code\ANmodel\ANmod\";
sf = 100;  % [kHz]
cutoff = 15;  % [ms]
data = PreprocessingSpikes_genDataAM(path, sf, cutoff);

% concatenate the content of the field into one big cell array (56x11)
dataCell = vertcat(data.ANmod20db7000Hz,data.ANmod40db7000Hz,...
    data.ANmod60db7000Hz,data.ANmod80db7000Hz, data.ANmod20db10500Hz,...
    data.ANmod40db10500Hz,data.ANmod60db10500Hz,data.ANmod80db10500Hz);

%% VS error analysis
VSoutliers_nr = numel(find(abs(VS_error*100) > 20));  % 13
VSoutliers_idx = find(abs(VS_error*100) > 20);  % 2,9,15,16,22,24,30,37,43,45,50,52,53
VSoutliers_vals = VS_error(VSoutliers_idx);

%% CI error analysis
CIoutliers_nr = numel(find(abs(CI_error*100) > 20));  % 1
CIoutliers_idx = find(abs(CI_error*100) > 20);  % 43
CIoutliers_vals = CI_error(CIoutliers_idx);

%% Get the dB, CF and ENVfq from the outliers
% VS
VSoutlier_CF = zeros(length(VSoutliers_idx),1);
VSoutlier_dB = zeros(length(VSoutliers_idx),1);
VSoutlier_ENVfq = zeros(length(VSoutliers_idx),1);
for k = 1:length(VSoutliers_idx)
    [VSoutlier_CF(k), VSoutlier_dB(k), VSoutlier_ENVfq(k)] = ...
        dataCell{VSoutliers_idx(k),[3,10,11]};
end

% CI
[CIoutlier_CF, CIoutlier_dB, CIoutlier_ENVfq] = ...
    dataCell{CIoutliers_idx,[3,10,11]};

