%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script creates the VS-CI plot for the non-AM ANmodel data. The data
% have been preprocessed in analysis_AN_GBC.m. Here, the VS and CI values
% are plotted against each other (color coded for AN/GBC, 40db/70db).
% Furthermore, the theoretical values are drawn into the same plot.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 0. Load the data (further reference: analysis_AN_GBC.m) 
load("VSCI_ANmodel.mat")

%% 1. Sample the theoretical VS-CI relationship (for plot)
kappa = 0.1:0.1:38;
% Nk = length(kappa);
VStheo = besseli(1,kappa) ./ besseli(0,kappa);
CItheo = besseli(0,2*kappa) ./ (besseli(0,kappa)).^2;

%% 2. Plot the results
figure
plot(VSCI_AN40(:,2), VSCI_AN40(:,1), 'b+')  % AN 40db
hold on
plot(VSCI_AN70(:,2), VSCI_AN70(:,1), 'ro')  % AN 70db
plot(VSCI_GBC40(:,2), VSCI_GBC40(:,1), 'g*')  % GBC 40db
plot(VSCI_GBC70(:,2), VSCI_GBC70(:,1), 'ys')  % GBC 70db
plot(CItheo, VStheo, '-', 'LineWidth', 1.1, 'color', 'k')  % theo VS-CI

title("VS-CI relationship for generated data (ANmodel)")
xlabel("CI")
ylabel("VS")
xlim([0,11])
ylim([0,1])
legend("AN, 40db","AN, 70db","GBC, 40db","GBC, 70db", ...
    "theoretical curve", 'Location', 'best')