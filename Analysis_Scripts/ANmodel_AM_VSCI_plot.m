%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script creates the VS-CI plot for the non-AM ANmodel data. The data
% have been preprocessed in analysis_AN_GBC.m. Here, the VS and CI values
% are plotted against each other (color coded for AN/GBC, 40db/70db).
% Furthermore, the theoretical values are drawn into the same plot.
% 
% (1) different symbols (circle, triangle, square, diamond) for different
% levels, (2) different colors for different modulation frequencies, and
% (3) filled and unfilled symbols for CF = 7000 and 10500 Hz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 0. Load the data (further reference: analysis_AN_GBC.m) 
load("VSCI_ANmodel_AM.mat")
VSCIcell = struct2cell(VSCI);  % convert struct to cell array
VSCImat = cell2mat(VSCIcell);  % convert cell to double

% order: 
% - entries 1-7  : 20dB, CF= 7000, ENVfq=100,1200,200,300,400,600,800
% - entries 8-14 : 40dB, CF= 7000, ENVfq=100,1200,200,300,400,600,800
% - entries 15-21: 60dB, CF= 7000, ENVfq=100,1200,200,300,400,600,800
% - entries 22-28: 80dB, CF= 7000, ENVfq=100,1200,200,300,400,600,800
% - entries 29-35: 20dB, CF=10500, ENVfq=100,1200,200,300,400,600,800
% - entries 30-42: 40dB, CF=10500, ENVfq=100,1200,200,300,400,600,800
% - entries 43-49: 60dB, CF=10500, ENVfq=100,1200,200,300,400,600,800
% - entries 50-56: 80dB, CF=10500, ENVfq=100,1200,200,300,400,600,800

%% 1. Sample the theoretical VS-CI relationship (for plot)
kappa = 0:0.1:15;
VStheo = besseli(1,kappa) ./ besseli(0,kappa);
CItheo = besseli(0,2*kappa) ./ (besseli(0,kappa)).^2;

%% 2. Plot the results
% define colors and symbols for the plot
cols = {[1 0 0], [0 1 0], [0 0 1], [1 1 0], [0 1 1], [0.5 0.3 0.2], ...
        [1 0 1], [0 0 0]};  % for mod. freq.: 100, 1200, 200, 300, 400, 600, 800 and theoretical curve
symb = {'d', 's', 'o', '<'};  % one for each dB level (20, 40, 60, 80)
    
% MarkerFaceColor indicates CF=7000Hz (filled) or 10500Hz (unfilled)

figure
N = size(VSCIcell, 1);
for k1 = 1:8
    for k2 = 1:7
        idx_temp = (k1-1)*7 + k2;
        if k1==1  % 20dB, 7000Hz
            p = plot(VSCImat(idx_temp, 2), ...
                     VSCImat(idx_temp, 1), ...
                     symb{1}, 'Color', cols{k2});
            p.MarkerFaceColor = p.Color;    
            hold on
        elseif k1==2  % 40dB, 7000Hz
            p = plot(VSCImat(idx_temp, 2), ...
                     VSCImat(idx_temp, 1), ...
                     symb{2}, 'Color', cols{k2});
            p.MarkerFaceColor = p.Color;
            hold on
        elseif k1==3  % 60dB, 7000Hz
            p = plot(VSCImat(idx_temp, 2), ...
                     VSCImat(idx_temp, 1), ...
                     symb{3}, 'Color', cols{k2});
            p.MarkerFaceColor = p.Color;
            hold on
        elseif k1==4  % 80dB, 7000Hz
            p = plot(VSCImat(idx_temp, 2), ...
                     VSCImat(idx_temp, 1), ...
                     symb{4}, 'Color', cols{k2});
            p.MarkerFaceColor = p.Color;
            hold on
            
        elseif k1==5  % 20dB, 10500Hz
            p = plot(VSCImat(idx_temp, 2), ...
                     VSCImat(idx_temp, 1), ...
                     symb{1}, 'Color', cols{k2});
            p.MarkerFaceColor = 'none';
            hold on
        elseif k1==6  % 40dB, 10500Hz
            p = plot(VSCImat(idx_temp, 2), ...
                     VSCImat(idx_temp, 1), ...
                     symb{2}, 'Color', cols{k2});
            p.MarkerFaceColor = 'none';
            hold on
        elseif k1==7  % 60dB, 10500Hz
            p = plot(VSCImat(idx_temp, 2), ...
                     VSCImat(idx_temp, 1), ...
                     symb{3}, 'Color', cols{k2});
            p.MarkerFaceColor = 'none';
            hold on
        elseif k1==8  % 80dB, 10500Hz
            p = plot(VSCImat(idx_temp, 2), ...
                     VSCImat(idx_temp, 1), ...
                     symb{4}, 'Color', cols{k2});
            p.MarkerFaceColor = 'none';
            hold on
        end
        
        p.MarkerSize = 7;
        p.LineWidth = 1.01;

    end
end
plot(CItheo, VStheo, '-', 'LineWidth', 1.1, 'color', 'k')  % theo VS-CI
title("VS-CI relation (AM data), filled: CF=7000Hz, unfilled: CF=10500Hz")
xlabel("CI")
ylabel("VS")
xlim([0.5, 2.5])
ylim([0, 1])

% work-around for customizing legend
h = zeros(8,1);
for k=1:8
h(k) = plot(NaN,NaN,'*','color',cols{k});
end
legend(h, "ENVfq = 100Hz", "ENVfq = 1200Hz", "ENVfq = 200Hz", "ENVfq = 300Hz", ...
       "ENVfq = 400Hz", "ENVfq = 600Hz", "ENVfq = 800Hz", 'theoretical relation', ...
       'Location', 'southeast')

%legend("20dB,7000Hz","40dB,7000Hz","60dB,7000Hz","80dB,7000Hz", ...
%    "20dB,10500Hz", "40dB,10500Hz", "60dB,10500Hz", "80dB,10500Hz", ...
%    "theoretical curve", 'Location', 'best')
