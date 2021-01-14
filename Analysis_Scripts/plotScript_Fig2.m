%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script creates all the figures for the panels A to G of Figure 2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% panel A: Raster plots for simulated spike trains (VSin = 0.3, 0.6, 0.9)


%% panel B: Phase histograms corresponding to the rasters in panel A


%% panel C: VS-kappa curve
kappa = 0:0.1:11;
VStheo = besseli(1,kappa) ./ besseli(0,kappa);
figure
plot(kappa, VStheo, '-k')
xlabel('concentration parameter kappa')
ylabel('Vector Strength')
title('VS-kappa curve')

%% panel D: SAC curves corresponding to the rasters in panel A


%% panel E: CI-kappa curve
kappa = 0:0.1:11;
CItheo = besseli(0,2*kappa) ./ (besseli(0,kappa)).^2;
figure
plot(kappa, CItheo, '-k')
xlabel('concentration parameter kappa')
ylabel('Correlation Index')
title('CI-kappa curve')

%% panel F: VS-CI plot (theoretical)
kappa = 0:0.1:45;
VStheo = besseli(1,kappa) ./ besseli(0,kappa);
CItheo = besseli(0,2*kappa) ./ (besseli(0,kappa)).^2;
figure
plot(CItheo, VStheo, '-k')
ylabel('Vector Strength')
xlabel('Correlation Index')
title('VS-CI curve')

%% panel G: Decay of SAC through stimulus duration


