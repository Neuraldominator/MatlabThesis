
% time steps
DTms  = 0.01; % [ms] time step -- 100kHz sampling rate

% simulation parameters 
NrepsBC = 400; % number of repetitions

% loop parameters
LoopFreq = 200:100:3000; % [Hz]
LoopLevel = [40,70]; % [dB SPL]

% GBC model parameters 
Me = 20; % number of AN inputs 
Ae = 0.40; % input amplitude
We = 0.32; % [ms] input duration
Tr = 1.20; % [ms] refractory period 
Ta = 0.25; % [ms] adaptation time constant
Sa = 0.80; % adaptation strength

% main loop
for ff = 1:length(LoopFreq)

for ll = 1:length(LoopLevel)
  
% pure tone parameters
PTfq = LoopFreq(ff); % [Hz]
PTdb = LoopLevel(ll); % [dB SPL]

% display info
disp([PTfq PTdb]); tic; 

% open AN file
infilename = sprintf('./ANdata/AN%.0fHz%.0fdB4SAC.mat',PTfq,PTdb);
load(infilename);

% output matrix
BCout = zeros(NrepsBC,length(ANout(1,:)));

% inner loop
for ii=1:NrepsBC
 Iex = (ii-1)*Me + (1:Me);
 SpEx = ANout(Iex,:);
 [BCout(ii,:), vmOut, thOut] = GBCmodelACC(SpEx, DTms, Ae, We, Tr, Ta, Sa);
end

% display time
toc;

% data output
outfilename = sprintf('GBC%.0fHz%.0fdB4SAC.mat',PTfq,PTdb);
save(outfilename,'BCout','PTfq','PTdb','tvms');

end % end of LoopLevel
end % end of LoopFreq

