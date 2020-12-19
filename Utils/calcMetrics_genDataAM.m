function [VSCIstruct] = calcMetrics_genDataAM(path, BW)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates the VS and CI for the preprocessed data from generated spike
% trains of the amplitude-modulated data.
%
% Example:
% >> path = "..\Source_Code\ANmodel\ANmod\";
% >> BW = 0.05;
% >> VSCI = calcMetrics_genDataAM(path, BW);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
%   - path (char): relative path to the data of interest.
%   - BW (double): coincidence window [ms] for CI calculation (default: 
%                  0.05).
%
% Output:
%   - VSCIstruct (struct): A struct with 8 fieldnames each containing a Nx2 
%                          matrix with the VS and CI value for each
%                          combination of decibel level and carrier
%                          frequenc<. The first column contains the VS and
%                          the second column contains the CI values.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler (Dec 2020)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin < 2
    BW = 0.05;
end

addpath("..\Source_Code\Ashida_2020_code\invivo")

%% set parameters
sf = 100;  % sampling freq. [kHz]
cutoff = 15;  % in [ms]
NB = 41;  % bin width for calcPhaseHist (irrelevant parameter)
TL = 6;  % max width for SAC (irrelevant parameter)

data = PreprocessingSpikes_genDataAM(path, sf, cutoff);
fn = fieldnames(data);

VSCIstruct = struct;
Nfields = size(fn,1);  % number of fields
for field = 1:Nfields
    con = getfield(data, fn{field});

    Ndata = size(con, 1);  % number of datasets
    VSCI = zeros(Ndata, 2);  % pre-allocation
    for idx = 1:Ndata
        T1 = con{idx,6} + con{idx,7};  % delay [ms] + cutoff [ms]
        T2 = con{idx,4};  % epoch [ms]
        [~, ~, VSCI(idx,1)] = calcPhaseHist(con{idx,1}, T1, T2, NB, con{idx,11});
        [~, ~, VSCI(idx,2), ~, ~] = calcSAC(con{idx,1}, BW, T1, T2, TL);
    end
    
    VSCIstruct = setfield(VSCIstruct, fn{field}, VSCI);
end