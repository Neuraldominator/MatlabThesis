%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to test the effect of limited time length on SAC 
% May-Oct 2020, Go Ashida (go.ashida@uni-oldenburg.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DT = 0.01; % [ms] time step
T = 100; % [ms] total time length
N = round(T/DT); % number of time steps
tv = (0:N-1) * DT; % [ms] time vector

M = 2000; % number of trials
F = 450; % [Hz] stimulus frequency
R = 0.8; % VS
L = 200; % [spikes/sec] mean rate 
P = pi; % initial phase

% generating inhomogeneous poisson spikes
disp('making spikes');
[SP,K] = PhaseLock(M,N,F,R,L,P,DT); 
SPin = cell(1,M);
for c = 1:M
  SPin{c} = tv( logical(SP(c,:)) );
end

% analysis parameters
T1 = 30; % [ms] analysis start time
T2 = 80; % [ms] analysis end time
NB = 41; % number of bins (for phase histogram)
BW = 0.05; % [ms] SAC bin width
TL = 10; % [ms] maximum time delay for SAC

% calculating VS and SAC
disp('calculating PH');
[PH,PHtv,VS] = calcPhaseHist(SPin,T1,T2,NB,F);
disp('calculating SAC');
[SAC,SACtv,CI] = calcSAC(SPin,BW,T1,T2,TL);

% theoretical values
VSthr = besseli(1,K) ./ besseli(0,K);
CIthr = besseli(0,2*K) ./ besseli(0,K).^2; 
vsfun = @(x)(besseli(1,x) ./ besseli(0,x) - VS);
SACest = besseli(0,2*K*cos(pi*F*SACtv/1000)) ./ besseli(0,K).^2; 

% decay factor
SACdecay = ones(1,length(SACtv));
SACdecay(SACtv<0) = 1 + SACtv(SACtv<0)/(T2-T1);
SACdecay(SACtv>0) = 1 - SACtv(SACtv>0)/(T2-T1);

% plotting
figure(1);
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Position', [450 60 560*1.0 420*2.0]);

% phase histogram
subplot(2,1,1); cla; hold on;
plot(PHtv,PH,'b-'); 
xlim([0,1]); ylim([0,max(PH)*1.2]);
text(0.1,max(PH)*1.12,sprintf('VSthr = %.4f',VSthr));
text(0.1,max(PH)*1.06,sprintf('VSout = %.4f',VS));
text(0.1,max(PH)*1.00,sprintf('Nspikes = %d',sum(PH)));

% SAC curve
subplot(2,1,2); cla; hold on;
plot(SACtv,SAC,'b-'); % calculated SAC
plot(SACtv,SACest,'r-'); % estimated SAC (without decay factor)
%plot(SACtv,SACest.*SACdecay,'g-');
plot(SACtv,max(SACest).*SACdecay,'k:'); % decay factor
xlim([-TL,TL]); ylim([0, max(SAC)*1.3]);
text(-8,max(SAC)*1.24,sprintf('CIthr = %.4f',CIthr));
text(-8,max(SAC)*1.16,sprintf('CIout = %.4f',CI));

% generate PDF/PNG figs
print('-dpdf', '-r1200', 'decay.pdf');
print('-dpng', '-r300', 'decay.png');

