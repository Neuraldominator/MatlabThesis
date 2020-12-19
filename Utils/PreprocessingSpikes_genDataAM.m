function [data] = PreprocessingSpikes_genDataAM(path, sf, cutoff)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Re-structures the data and truncates the spike trains to the desired 
% truncation window [delay + cutoff, epoch]. Only the first 400 spike
% train repititions are considered. Please change this section in the code
% below for more elaborate analyses.
% 
% Example:
% >> path = "..\Source_Code\ANmodel\ANmod\";
% >> sf = 100;  % in [kHz]
% >> cutoff = 15;  % in [ms]
% >> data = PreprocessingSpikes_genDataAM(path, sf, cutoff);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
%   - path (string): path to the data directory.
%   - sf (double): sampling frequency [kHz]. Inverse of the time step width
%                  [ms].
%   - cutoff (double): onset cutoff time [ms] after stimulation. Default
%                      is 15.
%
% Output:
%   - data (struct): struct with 8 fields (for each db level and envelope 
%                    frequency) containing the preprocessed data in the
%                    following order: spike trains, depvar, carrier freq.,
%                    epoch, durat, delay, cutoff, driven spike rate, total
%                    number of spikes (across all reps), db level, envelope
%                    frequency.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler (Dec 2020)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load all data in a cell array C
C = DataLoader_genDataAM(path);

% number of datasets
Ndata = size(C, 1);

% convert sampling frequency [kHz] to time steps [ms]
dt = 1/sf;  % in [ms]

% number of spike train repitions 
M = 400;  

% for-loop
c = cell(Ndata, 11);  % pre-allocation
for k1 = 1:Ndata
    % retrieve the stimulation start etc from the time vector 
    Nsteps = size(C{k1, 4}, 2);  % number of simulated time steps
    epoch = Nsteps * dt;  % total simulation length [ms]
    delay = find(C{k1, 4}==0)*0.01;  % start of stimulus [ms]
    
    % set the start T1 and end T2 of the analysis window
    T1 = delay + cutoff;
    T2 = epoch;  % stimulus goes until very end of simulation
    
    % convert binary spike trains to spike times "TSP" [ms]
    TSP = cell(M, 1);  % pre-allocation
    for k2 = 1:M
        spt_full = find(C{k1, 1}(k2, :) == 1) * dt;  % spike times [ms]
        TSP{k2} = spt_full(spt_full>=T1 & spt_full<=T2);  % truncation
    end
    
    % count number of spikes after stimulation
    [R, N, ~] = GetSpikeRate(TSP, T2-T1);
    
    % fill the cell array
    c{k1, 1} = TSP;             % spike trains [ms]
    c{k1, 2} = NaN;             % depvar: indicates spontaneous trial 
    c{k1, 3} = C{k1, 3};        % carrier freq [Hz]
    c{k1, 4} = epoch;           % epoch [ms] 
    c{k1, 5} = epoch - delay;   % durat [ms]
    c{k1, 6} = delay;           % delay [ms] 
    c{k1, 7} = cutoff;          % cutoff [ms]
    c{k1, 8} = R;               % driven spike rate [Hz]
    c{k1, 9} = N;               % total number of spikes 
    c{k1, 10} = C{k1, 2};       % db values [db SPL]
    c{k1, 11} = C{k1, 5};       % envelope modulation frequency [Hz]
    
end

% prepare the logical indexing for the 8 different cases
data = struct;

% decibel level [db SPL], can be either 20, 40, 60, or 80
log20db = cellfun(@(x) isequal(x,20), c(:,10));
log40db = cellfun(@(x) isequal(x,40), c(:,10));
log60db = cellfun(@(x) isequal(x,60), c(:,10));
log80db = cellfun(@(x) isequal(x,80), c(:,10));

% carrier frequency [Hz], can be either 7000 or 10500.
log7000Hz = cellfun(@(x) isequal(x,7000), c(:,3));
log10500Hz = cellfun(@(x) isequal(x,10500), c(:,3));

% Treat the 8 different cases
data = setfield(data, "ANmod20db7000Hz", c(log20db & log7000Hz,:));
data = setfield(data, "ANmod40db7000Hz", c(log40db & log7000Hz,:));
data = setfield(data, "ANmod60db7000Hz", c(log60db & log7000Hz,:));
data = setfield(data, "ANmod80db7000Hz", c(log80db & log7000Hz,:));
data = setfield(data, "ANmod20db10500Hz", c(log20db & log10500Hz,:));
data = setfield(data, "ANmod40db10500Hz", c(log40db & log10500Hz,:));
data = setfield(data, "ANmod60db10500Hz", c(log60db & log10500Hz,:));
data = setfield(data, "ANmod80db10500Hz", c(log80db & log10500Hz,:));


%--------------------------------------------------------------------------
function [R, Nsp, N] = GetSpikeRate(SPin, durat)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Truncate the spike train to the analysis window [T1, T2].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input: 
%  SPin (cell)   : cell array containing spike trains [ms].
%  durat (double): duration of analysis [ms] 
%
% Output: 
%  R (double)  : Spike Rate [sp/sec]
%  Nsp (double): Number of total spikes.
%  N (double)  : Number of trials/ spike trains
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler, Nov 2020 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% total number of spikes for truncated spike trains 
Nsp = sum(cellfun(@numel, SPin)); 

% total number of non-spontaneous trials of the session
N = numel(SPin);

% calculate the "driven spike rate" of the current session in [spikes/sec]
R = 1000 * Nsp / (durat * N); 