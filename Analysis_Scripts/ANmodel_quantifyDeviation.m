%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the amount of deviation between the theoretical and ANmodel 
% data (without AM data) VS and CI values. This is done in two ways:
% (A) "the difference of the theo and sim VS values for the same CI 
%     (= deviation along the y-axis)" and 
% (B) "the difference of the theo and sim CI values for the same VS 
%     (= deviation along the x-axis)" 
% This script loads the data saved under VSCI_ANmodel.mat, which was saved
% in the script "analysis_AN_GBC.m".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load("VSCI_ANmodel.mat");
% contains the variables: VSCI_AN40, VSCI_AN70, VSCI_GBC40, VSCI_GBC70

% VS values
VS_AN40 = VSCI_AN40(:,1);
VS_AN70 = VSCI_AN70(:,1);
VS_GBC40 = VSCI_GBC40(:,1);
VS_GBC70 = VSCI_GBC70(:,1);
VSemp = vertcat(VS_AN40, VS_AN70, VS_GBC40, VS_GBC70);

% CI values
CI_AN40 = VSCI_AN40(:,2);
CI_AN70 = VSCI_AN70(:,2);
CI_GBC40 = VSCI_GBC40(:,2);
CI_GBC70 = VSCI_GBC70(:,2);
CIemp = vertcat(CI_AN40, CI_AN70, CI_GBC40, CI_GBC70);

%% Concentration parameter for von Mises distribution
Ndata = length(VSemp);

VStheo = zeros(Ndata, 1);
CItheo = zeros(Ndata, 1);

for k = 1:Ndata
    % go from VS to estimated CI
    vsfun = @(K)(besseli(1,K) ./ besseli(0,K) - VSemp(k));
    Kvs = fsolve(vsfun, 1.0, optimset('Display','off'));
    CItheo(k) = besseli(0,2*Kvs) ./ (besseli(0,Kvs)^2);

    % go from CI to estimated VS
    cifun = @(K)(besseli(0,2*K) ./ besseli(0,K)^2 - CIemp(k));
    Kci = fsolve(cifun, 1.0, optimset('Display','off'));
    VStheo(k) = besseli(1,Kci) ./ besseli(0,Kci);

end

%% Calculate Errors 
% 1:29 is AN 40db, 30:58 is AN 70db, 59:87 is GBC 40db, 88:116 is GBC 70db
VS_error = (VSemp - VStheo) ./ VStheo;
CI_error = (CIemp - CItheo) ./ CItheo;

%% Plot results
bin_width = 5;  % 2.5
edges = -205:bin_width:205;  % -21.25:bin_width:21.75

figure
% VS, AN
subplot(2,2,1)
histogram(100*VS_error(1:58), edges)
title("VS Error (AN): (VSemp-VStheo)/VStheo")
xlabel("rel. error [%]")
ylabel("counts")

% CI, AN
subplot(2,2,2)
histogram(100*CI_error(1:58), edges)
title("CI Error (AN): (CIemp-CItheo)/CItheo")
xlabel("rel. error [%]")
ylabel("counts")

% VS, GBC
subplot(2,2,3)
histogram(100*VS_error(end-58:end), edges)
title("VS Error (GBC): (VSemp-VStheo)/VStheo")
xlabel("rel. error [%]")
ylabel("counts")

% CI, GBC
subplot(2,2,4)
histogram(100*CI_error(end-58:end), edges)
title("CI Error (GBC): (CIemp-CItheo)/CItheo")
xlabel("rel. error [%]")
ylabel("counts")
