function [data] = PreprocessingSpikes_genData(path, db, celltype, sf, cutoff)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Re-structures the data and truncates the spike trains to the desired 
% truncation window [delay + cutoff, epoch]. Only the first 400 spike
% train repititions are considered. Please change this section in the code
% below for more elaborate analyses.
% 
% Example:
% >> path_GBC = "..\Source_Code\ANmodel\GBCdata\";
% >> sf = 100;  % in [kHz]
% >> cutoff = 15;  % in [ms]
% >> data = PreprocessingSpikes_genData(path_GBC, 40, "GBC", sf, cutoff);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
%   - path (string): path to the data directory.
%   - db (double): decibel level [db SPL]
%   - celltype (string): type of cell the data reflects ("AN", or "GBC")
%   - sf (double): sampling frequency [kHz]. Inverse of the time step width
%                  [ms].
%   - cutoff (double): onset cutoff time [ms] after stimulation. Default
%                      is 15.
%
% Output:
%   - data (struct): struct with one field containing the preprocessed data
%                    in the following order: spike trains, depvar,
%                    frequency, epoch, durat, delay, cutoff, driven spike
%                    rate, total number of spikes (across all reps), db
%                    level.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler (Dec 2020)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% convert sampling frequency [kHz] to time steps [ms]
dt = 1/sf;  % in [ms]

% number of spike train repitions 
M = 400;  

% load the data from the specified folder with the desired properties
raw_data = DataLoader_genData(path, db, celltype);
par = fieldnames(raw_data);  % retrieve the fieldname; alt.: par = celltype + "data" + string(db) + "db";  
con = getfield(raw_data, par{1});  % get the field content

% number of datasets
Ndata = size(con, 1);
c = cell(Ndata, 10);  % pre-allocation
for k1 = 1:Ndata
    % retrieve the stimulation start etc from the time vector 
    Nsteps = size(con{k1, 4}, 2);  % number of simulated time steps
    epoch = Nsteps * dt;  % total simulation length [ms]
    delay = find(con{k1,4}==0)*0.01;  % start of stimulus [ms]
    
    % set the start T1 and end T2 of the analysis window
    T1 = delay + cutoff;
    T2 = epoch;  % stimulus goes until very end of simulation
    
    % convert binary spike trains to spike times "TSP" [ms]
    TSP = cell(M, 1);  % pre-allocation
    for k2 = 1:M
        spt_full = find(con{k1, 1}(k2, :) == 1) * dt;  % spike times [ms]
        TSP{k2} = spt_full(spt_full>=T1 & spt_full<=T2);  % truncation
    end
    
    % count number of spikes after stimulation
    [R, N, ~] = GetSpikeRate(TSP, T2-T1);
    
    % fill the cell array
    c{k1, 1} = TSP;             % spike trains [ms]
    c{k1, 2} = NaN;             % depvar: indicates spontaneous trial 
    c{k1, 3} = con{k1, 3};      % freq [Hz]
    c{k1, 4} = epoch;           % epoch [ms] 
    c{k1, 5} = epoch - delay;   % durat [ms]
    c{k1, 6} = delay;           % delay [ms] 
    c{k1, 7} = cutoff;          % cutoff [ms]
    c{k1, 8} = R;               % driven spike rate [Hz]
    c{k1, 9} = N;               % total number of spikes 
    c{k1, 10} = con{k1, 2};     % db values
    
end

data = struct;
data = setfield(data, par{1}, c);


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
