function [VSCI] = calcMetrics_genData(path, db, celltype, BW)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates the VS and CI for the preprocessed data from generated spike
% trains.
%
% Example:
% >> path = "..\Source_Code\ANmodel\ANdata\ANdata0\";
% >> db = 40;
% >> celltype = "AN"; 
% >> BW = 0.05;
% >> VSCI = calcMetrics_genData(path, db, celltype, BW);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
%   - path (char): relative path to the data of interest.
%   - db (double): decibel level (can be 40 or 70).
%   - celltype (string): celltype (can be "AN" or "GBC").
%   - BW (double): coincidence window [ms] for CI calculation (default: 
%                  0.05).
%
% Output:
%   - VSCI (double): A Nx2 matrix with the VS and CI value for each
%                    dataset. The first column contains the VS and the
%                    second column contains the CI values.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comment: to change the analysis window, you have to edit the T1 or T2
% parameters below. For T2 = con{idx,4}, the analysis end is at 200ms.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler (Dec 2020)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 4
    BW = 0.05;
end

addpath("..\Source_Code\Ashida_2020_code\invivo")

%% set parameters
sf = 100;  % sampling freq. [kHz]
cutoff = 15;  % in [ms]
NB = 41;  % bin width for calcPhaseHist (irrelevant parameter)
TL = 6;  % max width for SAC (irrelevant parameter)

data = PreprocessingSpikes_genData(path, db, celltype, sf, cutoff);
fn = fieldnames(data);
con = getfield(data, fn{1});

Ndata = size(con, 1);  % number of datasets
VSCI = zeros(Ndata, 2);  % pre-allocation
for idx = 1:Ndata
    T1 = con{idx,6} + con{idx,7};  % delay [ms] + cutoff [ms]
    T2 = 190;  % T2 = con{idx,4};  % custom value or epoch [ms]
    [~, ~, VSCI(idx,1)] = calcPhaseHist(con{idx,1}, T1, T2, NB, con{idx,3});
    [~, ~, VSCI(idx,2), ~, ~] = calcSAC(con{idx,1}, BW, T1, T2, TL);
end
