
% time parameters
DTms  = 0.01; % [ms] time step -- 100kHz sampling rate
Tall  = 200; % [ms] entire duration of simulation
Tinit = 25; % [ms] starting time of stimulus
Tonset = 15; % [ms] onset cutoff
T1 = Tinit + Tonset; % [ms] start of analysis window
T2 = T1 + 150; % [ms] end of analysis window

% loop parameters
CF1 = 7000; % [Hz]
CF2 = 10500; % [Hz]
LoopModFreq = [ 100, 200, 300, 400, 600, 800, 1200 ]; % [Hz]
LoopLevel = [ 20,40,60,80 ]; % [dB SPL]

% VS array
vs1 = zeros(length(LoopLevel),length(LoopModFreq));
vs2 = zeros(length(LoopLevel),length(LoopModFreq));

% fig windows
figure(1); clf; 
set(gcf, 'Position', [20 20 560*1.8 420*2.2]);
set(gcf, 'DefaultAxesFontSize',8);
set(gcf, 'DefaultTextFontSize',8);

figure(2); clf; 
set(gcf, 'Position', [220 20 560*1.8 420*2.2]);
set(gcf, 'DefaultAxesFontSize',8);
set(gcf, 'DefaultTextFontSize',8);


% main loop
for ff = 1:length(LoopModFreq)

for ll = 1:length(LoopLevel)

% sound parameters
EnvFq = LoopModFreq(ff); % [Hz]
Cardb = LoopLevel(ll); % [dB SPL]

% display info
disp([EnvFq Cardb]); tic; 

% loading data
filename1 = sprintf('./ANmod/ANmod%.0fHz%.0fHz%.0fdB4SAC.mat',CF1,EnvFq,Cardb);
filename2 = sprintf('./ANmod/ANmod%.0fHz%.0fHz%.0fdB4SAC.mat',CF2,EnvFq,Cardb);
data1 = load(filename1); 
data2 = load(filename2);

% calculating PSTH, VS, etc.
stats1 = calcVSstats(data1.ANout, DTms, EnvFq, [T1,T2], [0,Tinit]);
stats2 = calcVSstats(data2.ANout, DTms, EnvFq, [T1,T2], [0,Tinit]);
vs1(ll,ff) = stats1.VS;
vs2(ll,ff) = stats2.VS;

% plotting
figure(1); 
subplot(7,4,(ff-1)*4+ll); cla; hold on;
plot(stats1.PSTHtv-Tinit,stats1.PSTH,'b-');
xlim([-5,35]); ylim([0,3300]); 
text(0,3200,sprintf('CF %d Hz Mod %d Hz %d dB',CF1,EnvFq,Cardb));

figure(2); 
subplot(7,4,(ff-1)*4+ll); cla; hold on;
plot(stats2.PSTHtv-Tinit,stats2.PSTH,'r-');
xlim([-5,35]); ylim([0,3300]); 
text(0,3200,sprintf('CF %d Mod %d Hz %d dB',CF2,EnvFq,Cardb));

end % end of LoopModFreq
end % end of LoopLevel

% VS plot
figure(3); clf; 
set(gcf, 'Position', [20+ll*40 20 560*1.5 420*2.2]);
set(gcf, 'DefaultAxesFontSize',8);
set(gcf, 'DefaultTextFontSize',8);
subplot(1,1,1); cla; hold on; 
plot(LoopModFreq,vs1(1,:),'bo-'); % 20 dB
plot(LoopModFreq,vs1(2,:),'b^-'); % 40 dB
plot(LoopModFreq,vs1(3,:),'bs-'); % 60 dB
plot(LoopModFreq,vs1(4,:),'bd-'); % 80 dB
plot(LoopModFreq,vs2(1,:),'ro-'); % 20 dB
plot(LoopModFreq,vs2(2,:),'r^-'); % 40 dB
plot(LoopModFreq,vs2(3,:),'rs-'); % 60 dB
plot(LoopModFreq,vs2(4,:),'rd-'); % 80 dB
xlim([0,1300]); ylim([0,0.8]);
legend('7000Hz20dB','7000Hz40dB','7000Hz60dB','7000Hz80dB',...
   '10500Hz20dB','10500Hz40dB','10500Hz60dB','10500Hz80dB',...
   'Location','northeast');






