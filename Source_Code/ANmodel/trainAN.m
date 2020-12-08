% time steps
DTms  = 0.01; % [ms] time step -- 100kHz sampling rate
DTsec = DTms*1e-3; % [sec] time step -- for BEZ model

% simulation parameters 
Nreps = 8000; % number of repetitions

% time lengths
Tall  = 200; % [ms] entire duration of simulation
Tinit = 25; % [ms] starting time of stimulus
Tramp = 5;% [ms] duration of stimulus ramp
Nall  = round(Tall /DTms); 
Ninit = round(Tinit/DTms); 
Nramp = round(Tramp/DTms); 
tvms = (0:Nall-1)*DTms-Tinit; % time vector (stimulus starts at time zero)

% stim sound envelope
WavEnv = zeros(1,Nall); % initialization with zero
WavEnv(Ninit+1       : Ninit+Nramp+1) = (0:Nramp)/Nramp; % upward ramp
WavEnv(Ninit+Nramp+1 : end) = 1; % stimulus

% loop parameters
LoopFreq = 200:100:3000; % [Hz]
LoopFreq = fliplr(LoopFreq); % [Hz]
LoopLevel = [40,70]; % [dB SPL]

% main loop
for ff = 1:length(LoopFreq)

for ll = 1:length(LoopLevel)
  
% pure tone parameters
PTfq = LoopFreq(ff); % [Hz]
PTdb = LoopLevel(ll); % [dB SPL]
PTpa = 10^(PTdb/20)*20e-6; % [Pa] <- dB SPL re 20 uPa
PTphase = 0; % [rad] initial phase

% stimulus sound waveform
WavCar = sin( 2 * pi * PTfq * ((tvms-Tinit)/1000) + PTphase); % carrier sine wave
WavSound = sqrt(2) * PTpa * WavEnv .* WavCar; 

% AN model parameters
ANfq = PTfq; % [Hz] CF of AN fiber
ANspont = 70; % spontaneous rate [spikes/sec]
ANtabsmax = 1.5*461e-6; ANtabsmin = 1.5*139e-6;
ANtrelmax = 894e-6; ANtrelmin = 131e-6;
ANtabs = (ANtabsmax - ANtabsmin)*0.5 + ANtabsmin;
ANtrel = (ANtrelmax - ANtrelmin)*0.5 + ANtrelmin; 

% calling IHC model 
vIHC = model_IHC_BEZ2018(WavSound,ANfq,1,DTsec,Tall/1000,1,1,1);

% display info
disp([PTfq PTdb]); tic; 

% calling AN model
ANout = zeros(Nreps,Nall); 
for i=1:Nreps
 if(mod(i,1000)==0); disp(i); end
 ANout(i,:) = model_Synapse_BEZ2018(vIHC,ANfq,1,DTsec,1,1,ANspont,ANtabs,ANtrel);
end

% display time
toc;

% data output
filename = sprintf('AN%.0fHz%.0fdB4SAC.mat',PTfq,PTdb);
save(filename,'ANout','PTfq','PTdb','tvms','WavSound','vIHC');

end % end of LoopLevel
end % end of LoopFreq

