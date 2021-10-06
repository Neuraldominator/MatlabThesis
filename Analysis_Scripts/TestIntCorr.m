% testing internal correlation for gator NL unit
% Oct 2021, Go Ashida

addpath("..\Source_Code\Ashida_2020_code\invivo")
addpath("..\Source_Code\Ashida_2020_code\binwidth")

% loading data & assigning spikes for non-spont trials
load('../Raw_Data/gatorNL/14.02.4.spikes.mat');
Nreps = sum(depvar~=-6666); % nos-spont trials
SPin = cell(1,Nreps); % spike timing data cell 
i = 0; % counter
for c = 1:length(spikes)
 if(depvar(c)~=-6666) % remove spont trials
  i = i+1;
  SPin{i} = spikes{c};
 end
end

% analysis settings
T1 = delay + 15; % [ms] analysis start time
T2 = delay + durat; % [ms] analysis end time
NB = 41; % number of bins (for phase histogram)
BW = 0.05; % [ms] SAC bin width
TL = 6; % [ms] maximum time delay for SAC

% calcumating VS and SAC -- in vivo data
[PH,PHtv,VS] = calcPhaseHist(SPin,T1,T2,NB,freq);
[SAC,SACtv,CI] = calcSAC(SPin,BW,T1,T2,TL);

% calculating spike counts and rate -- in vivo data
Nsp = sum(PH); % total number of spikes
Tall = Nreps * (T2-T1); % [ms] total time length 
rate = Nsp*1000/Tall; % [spike/sec] mean rate

% generating surrogate data 
DT = 0.01; % [ms] time step
M = Nreps; % number of trials
F = freq; % [Hz] stimulus frequency
L = rate; % [spikes/sec] mean rate 
T = epoch; % [ms] total time length
N = round(T/DT); % number of time steps
tv = (0:N-1) * DT; % [ms] time vector

% assigning rate vector
C = freq*epoch/1000; % total number of cycles
dumDT = 1000/freq/NB; % [ms] time step for PH
dumTV = (0:C*NB-1) * dumDT; % time vector for repeated PH
dumPH = repmat(PH,1,C)/mean(PH); % repeated and normalized PH
allPH = interp1(dumTV,dumPH,tv); % interpolate with step DT
Q = allPH * L * DT /1000; % mean spike number per step 

% Generate Poissonian spikes
H = Q .* exp(-Q); 
rmat = rand(M,N); 
A = double( rmat < repmat(H,M,1) ); 

SPsim = cell(1,M);
for c = 1:M
  SPsim{c} = tv( logical(A(c,:)) );
end

% calcumating VS and SAC -- in vivo data
[PHsim,PHtv,VSsim] = calcPhaseHist(SPsim,T1,T2,NB,freq);
[SACsim,SACtv,CIsim] = calcSAC(SPsim,BW,T1,T2,TL);

% calculating spike counts and rate -- in vivo data
NspSim = sum(PHsim); % total number of spikes
TallSim = M * (T2-T1); % [ms] total time length 
rateSim = NspSim*1000/TallSim; % [spike/sec] mean rate

% plotting data
figure(1);
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Position', [50 100 560*1.0 420*1.5]);
%set(gcf, 'DefaultAxesFontSize',8);
%set(gcf, 'DefaultTextFontSize',10);

% phase histogram
subplot(2,1,1); cla; hold on;
plot(PHtv,PH,'b-'); 
plot(PHtv,PHsim*mean(PH)/mean(PHsim),'r-'); 
xlim([0,1]); ylim([0,max(PH)*1.2]);
text(0.1,max(PH)*1.15,sprintf('freq = %.0f',freq));
text(0.1,max(PH)*1.0,sprintf('rate = %.1f',rate));
text(0.1,max(PH)*0.9,sprintf('VSout = %.4f',VS));
text(0.1,max(PH)*0.8,sprintf('Nspikes = %.0f',Nsp));
text(0.1,max(PH)*0.6,sprintf('rate = %.1f',rateSim));
text(0.1,max(PH)*0.5,sprintf('VSout = %.4f',VSsim));
text(0.1,max(PH)*0.4,sprintf('Nspikes = %.0f',NspSim));

% SAC curve
subplot(2,1,2); cla; hold on;
plot(SACtv,SAC,'b-'); 
plot(SACtv,SACsim,'r-'); 
xlim([-31,31])
ylim([0, max(SAC)*1.3]);
text(-5,max(SAC)*1.2,sprintf('CIemp = %.4f',CI));
text(-5,max(SAC)*1.0,sprintf('CIsim = %.4f',CIsim));

% generate PDF/PNG figs
% print('-dpdf', '-r1200', 'decay.pdf');
% print('-dpng', '-r300', 'decay.png');