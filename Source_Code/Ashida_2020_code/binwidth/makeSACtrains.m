%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to create phase-locked spike trains (for BW analysis)
% May-Oct 2020, Go Ashida (go.ashida@uni-oldenburg.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parameters
DT = 0.002; % [ms] 
Ddef = 100; % [ms] total time length
Mdef = 400; % number of trials
Ndef = round(Ddef/DT); % number of time steps in each trial
Dall = Ddef* Mdef; % [ms] total time length
Nall = round(Dall/DT); % number of time steps
tv = (0:Nall-1) * DT; % [ms] time vector

F = 500; % [Hz] stimulus frequency
R = 0.60; % VS
L = 200; % [spikes/sec] mean rate 
P = 0; % initial phase
Nreps = 1000; % number of repetitions 

% make spike trains
SPall = cell(1,Nreps);
for r = 1:Nreps
if(mod(r,10)==0); disp(r); end % show progress
[SP,K] = PhaseLock(1,Nall,F,R,L,P,DT); 
SPall{r} = tv( logical(SP) );
end

% saving phase-locked spike data
outfile = sprintf('SPv%.0fall.mat',R*100);
%save(outfile,'SPall','DT','Ddef','Mdef','F','R','L','P','Nreps','K'); % uncomment this to save data

