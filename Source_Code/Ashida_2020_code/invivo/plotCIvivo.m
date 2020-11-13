%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script for SAC/VS analysis of in vivo data  
% May-Oct 2020, Go Ashida (go.ashida@uni-oldenburg.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% data settings
dirs = {'gatorNM', 'gatorNL', 'chickNM', 'chickNL', 'owlNM'};
cols = {[0,0.6,0],[0,0.4,0.2], [0.8,0,0],[0.4,0.2,0], [0,0,0.8]};
symb = { 'd', '+', 's', 'x', 'o' };

% cell arrays for storing data
FQall = cell(1,length(dirs)); 
VSall = cell(1,length(dirs)); 
CIall = cell(1,length(dirs)); 
NSall = cell(1,length(dirs)); 
DRall = cell(1,length(dirs)); 

% loop for data directories
for d = 1:length(dirs)

% get file names
files = dir( sprintf('./data/%s/*.mat',dirs{d}) ); 

% data vectors
FQall{d} = zeros(1,length(files));
VSall{d} = zeros(1,length(files));
CIall{d} = zeros(1,length(files));
NSall{d} = zeros(1,length(files));
DRall{d} = zeros(1,length(files));

% loop through files
for f = 1:length(files)

% data loading
infile = sprintf('./data/%s/%s',dirs{d},files(f).name); 
load(infile); 

% assigning spikes for non-spont trials
Nreps = sum(depvar~=-6666); 
SPin = cell(1,Nreps); 
i = 0; 
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

% calcumating VS and SAC
[PH,PHtv,VS] = calcPhaseHist(SPin,T1,T2,NB,freq);
[SAC,SACtv,CI] = calcSAC(SPin,BW,T1,T2,TL);

% calculating spike counts and rate
Nsp = sum(PH); % total number of spikes
Tall = Nreps * (T2-T1); % [ms] total time length 
rate = Nsp*1000/Tall; % [spike/sec] mean rate

% storing data
FQall{d}(f) = freq; 
VSall{d}(f) = VS; 
CIall{d}(f) = CI; 
NSall{d}(f) = Nsp;
DRall{d}(f) = rate;
 
end % end of f (files)
 
end % end of d (dirs)

% theoretical values for VS and CI
Kall = 0:0.01:40; 
VSest = besseli(1,Kall) ./ besseli(0,Kall); 
CIest = besseli(0,2*Kall) ./ besseli(0,Kall).^2; 

% plotting all data
figure(1001);
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Position', [50 100 560*1.5 420*1.5]);
set(gcf, 'DefaultAxesFontSize',8);
set(gcf, 'DefaultTextFontSize',10);

subplot(1,1,1); cla; hold on; 
for d = 1:length(dirs)
 Ndata = 0; % counter for number of accepted data
 for f = 1:length(VSall{d})
  if(DRall{d}(f)>30 && NSall{d}(f)>400)
   Ndata = Ndata+1; 
   plot(CIall{d}(f),VSall{d}(f),symb{d},'color',cols{d});
  end
 end
 text(10,0.3-d*0.04,sprintf('%s (N=%d)',dirs{d},Ndata));
 plot(9.8,0.295-d*0.04,symb{d},'color',cols{d});
end

plot(CIest,VSest,'k-');
plot(CIest*1.4,VSest,':','color',[0.3,0.3,0.3]);
plot(CIest*0.7,VSest,':','color',[0.3,0.3,0.3]);
xlim([0.5,11.5]); ylim([0,1]); xlabel('CI'); ylabel('VS');

% generate PDF/PNG figs
%print('-dpdf', '-r1200', 'VSCIall.pdf');
%print('-dpng', '-r300', 'VSCIall.png');

