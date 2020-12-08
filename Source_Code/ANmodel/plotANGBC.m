
% time parameters
DTms  = 0.01; % [ms] time step -- 100kHz sampling rate
Tall  = 200; % [ms] entire duration of simulation
Tinit = 25; % [ms] starting time of stimulus
Tramp = 5;% [ms] duration of stimulus ramp
Tonset = 15; % [ms] onset cutoff
T1 = Tinit + Tonset; % [ms] start of analysis window
T2 = T1 + 150; % [ms] end of analysis window

% loop parameters
LoopFreq = 200:100:3000; % [Hz]
LoopLevel = [40,70]; % [dB SPL]

% VS array
ANvs = zeros(length(LoopLevel),length(LoopFreq));
BCvs = zeros(length(LoopLevel),length(LoopFreq));

% main loop
for ll = 1:length(LoopLevel)

figure(ll); clf; 
set(gcf, 'Position', [20+ll*40 20 560*1.8 420*2.2]);
set(gcf, 'DefaultAxesFontSize',8);
set(gcf, 'DefaultTextFontSize',8);

figure(ll+2); clf; 
set(gcf, 'Position', [220+ll*40 20 560*1.8 420*2.2]);
set(gcf, 'DefaultAxesFontSize',8);
set(gcf, 'DefaultTextFontSize',8);

for ff = 1:length(LoopFreq)

% pure tone parameters
PTfq = LoopFreq(ff); % [Hz]
PTdb = LoopLevel(ll); % [dB SPL]

% display info
disp([PTfq PTdb]); tic; 

% loading data
ANfilename = sprintf('./ANdata/AN%.0fHz%.0fdB4SAC.mat',PTfq,PTdb);
BCfilename = sprintf('./GBCdata/GBC%.0fHz%.0fdB4SAC.mat',PTfq,PTdb);
load(ANfilename); 
load(BCfilename);

% calculating PSTH, VS, etc.
ANstats = calcVSstats(ANout, DTms, PTfq, [T1,T2], [0,Tinit]);
BCstats = calcVSstats(BCout, DTms, PTfq, [T1,T2], [0,Tinit]);
ANvs(ll,ff) = ANstats.VS;
BCvs(ll,ff) = BCstats.VS;

% plotting
figure(ll); 
subplot(8,4,ff); cla; hold on;
plot(ANstats.PSTHtv-Tinit,ANstats.PSTH,'r-');
xlim([-5,35]); ylim([0,3300]); 
%xlim([-Tinit,Tall-Tinit]); ylim([0,3300]); 
text(10,3200,sprintf('AN %d Hz %d dB',PTfq,LoopLevel(ll)));

figure(ll+2); 
subplot(8,4,ff); cla; hold on;
plot(BCstats.PSTHtv-Tinit,BCstats.PSTH,'b-');
xlim([-5,35]); ylim([0,3300]); 
text(10,3200,sprintf('GBC %d Hz %d dB',PTfq,LoopLevel(ll)));

end % end of LoopLevel
end % end of LoopFreq

% VS plot
figure(100); clf; 
set(gcf, 'Position', [20+ll*40 20 560*1.5 420*2.2]);
set(gcf, 'DefaultAxesFontSize',8);
set(gcf, 'DefaultTextFontSize',8);
subplot(1,1,1); cla; hold on; 
plot(LoopFreq,ANvs(1,:),'mx-');
plot(LoopFreq,ANvs(2,:),'ro-');
plot(LoopFreq,BCvs(1,:),'cx-');
plot(LoopFreq,BCvs(2,:),'bo-');
xlim([0,3000]); ylim([0,1]);
legend(sprintf('AN %d dB',LoopLevel(1)),sprintf('AN %d dB',LoopLevel(2)),...
       sprintf('GBC %d dB',LoopLevel(1)),sprintf('GBC %d dB',LoopLevel(2)),'Location','southwest');






