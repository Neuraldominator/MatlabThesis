%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script creates the VS-CI plot for the non-AM ANmodel data. The data
% have been preprocessed in analysis_AN_GBC.m. Here, the VS and CI values
% are plotted against each other (color coded for AN/GBC, 40db/70db).
% Furthermore, the theoretical values are drawn into the same plot.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 0. Load the data (further reference: analysis_AN_GBC.m) 
load("VSCI_ANmodel_AM.mat")
VSCIcell = struct2cell(VSCI);  % convert struct to cell array

%% 1. Sample the theoretical VS-CI relationship (for plot)
kappa = 0.1:0.1:38;
VStheo = besseli(1,kappa) ./ besseli(0,kappa);
CItheo = besseli(0,2*kappa) ./ (besseli(0,kappa)).^2;

%% 2. Plot the results
% define colors and symbols for the plot
cols = {[0,0.6,0],[0,0.4,0.2],[0.8,0,0],[0.4,0.2,0], ... 
        [0,0,0.8],[0.33,0.33,0.66],[0.8,0.8,0.2],[0,0.4,0.5]};
symb = {'d', '+', 's', 'x', 'o', '^', 'v', '<'};
    
figure
N = size(VSCIcell, 1);
for k = 1:N
    plot(VSCIcell{k}(:,2), VSCIcell{k}(:,1), symb{k}, 'Color', cols{k})
    hold on
end
plot(CItheo, VStheo, '-', 'LineWidth', 1.1, 'color', 'k')  % theo VS-CI
hold off
title("VS-CI relationship for AM generated data (ANmodel)")
xlabel("CI")
ylabel("VS")
xlim([0,11])
ylim([0,1])
legend("20dB,7000Hz","40dB,7000Hz","60dB,7000Hz","80dB,7000Hz", ...
    "20dB,10500Hz", "40dB,10500Hz", "60dB,10500Hz", "80dB,10500Hz", ...
    "theoretical curve", 'Location', 'best')