% time steps
DTms  = 0.01; % [ms] time step -- 100kHz sampling rate
DTsec = DTms*1e-3; % [sec] time step -- for BEZ model

% simulation parameters 
Nreps = 800; % number of repetitions

% time lengths
Tall  = 200; % [ms] entire duration of simulation
Tinit = 25; % [ms] starting time of stimulus
Nall  = round(Tall /DTms); 
Ninit = round(Tinit/DTms); 
tvms = (0:Nall-1)*DTms-Tinit; % time vector (stimulus starts at time zero)

% loop parameters
CF = 7000; % [Hz]
%CF = 10500; % [Hz]
LoopModFreq = [ 100, 200, 300, 400, 600, 800, 1200 ]; % [Hz]
LoopLevel = [ 20,40,60,80 ]; % [dB SPL]

% main loop
for ff = 1:length(LoopModFreq)

for ll = 1:length(LoopLevel)
  
% carrier tone parameters
CarFq = CF; % [Hz] carrier frequency
Cardb = LoopLevel(ll); % [dB SPL]
CarPa = 10^(Cardb/20)*20e-6; % [Pa] <- dB SPL re 20 uPa
CarPhase = 0; % [rad] initial phase

% stim sound envelope
EnvFq = LoopModFreq(ff); % [Hz] envelope modulation frequency
WavEnv = zeros(1,Nall); % initialization with zero
WavEnv(Ninit+1:end) = (1-cos(2*pi*EnvFq*(0:Nall-Ninit-1)*DTms/1000))/2; % stimulus

% stimulus sound waveform
WavCar = sin( 2 * pi * CarFq * ((tvms-Tinit)/1000) + CarPhase); % carrier sine wave
WavSound = sqrt(2) * CarPa * WavEnv .* WavCar; 

% AN model parameters
ANfq = CarFq; % [Hz] CF of AN fiber equal to carrier freq
ANspont = 70; % spontaneous rate [spikes/sec]
ANtabsmax = 1.5*461e-6; ANtabsmin = 1.5*139e-6;
ANtrelmax = 894e-6; ANtrelmin = 131e-6;
ANtabs = (ANtabsmax - ANtabsmin)*0.5 + ANtabsmin;
ANtrel = (ANtrelmax - ANtrelmin)*0.5 + ANtrelmin; 

% calling IHC model 
vIHC = model_IHC_BEZ2018(WavSound,ANfq,1,DTsec,Tall/1000,1,1,1);

% display info
disp([CarFq EnvFq Cardb]); tic; 

% calling AN model
ANout = zeros(Nreps,Nall); 
for i=1:Nreps
 if(mod(i,100)==0); disp(i); end
 ANout(i,:) = model_Synapse_BEZ2018(vIHC,ANfq,1,DTsec,1,1,ANspont,ANtabs,ANtrel);
end

% display time
toc;

% data output
filename = sprintf('ANmod%.0fHz%.0fHz%.0fdB4SAC.mat',CarFq,EnvFq,Cardb);
save(filename,'ANout','CarFq','EnvFq','Cardb','tvms','WavSound','vIHC');

end % end of LoopLevel
end % end of LoopFreq

