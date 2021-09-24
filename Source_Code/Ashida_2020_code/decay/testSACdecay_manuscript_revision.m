%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to test the effect of limited time length on SAC 
% May-Oct 2020, Go Ashida (go.ashida@uni-oldenburg.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edited by Dominik Kessler (24th Sept 2021)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DT = 0.01; % [ms] time step
T = 100; % [ms] total time length
N = round(T/DT); % number of time steps
tv = (0:N-1) * DT; % [ms] time vector

M = 2000; % number of trials
F = 500; % [Hz] stimulus frequency
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

%% analysis parameters
NB = 41; % number of bins (for phase histogram)
TL = 10; % [ms] maximum time delay for SAC
BW = 0.05; % [ms] SAC bin width

% 50ms
T1_D50 = 30; % [ms] analysis start time
T2_D50 = 80; % [ms] analysis end time

% 40ms
T1_D40 = 30; % [ms] analysis start time
T2_D40 = 70; % [ms] analysis end time

% 30ms
T1_D30 = 30; % [ms] analysis start time
T2_D30 = 60; % [ms] analysis end time

% 20ms
T1_D20 = 30; % [ms] analysis start time
T2_D20 = 50; % [ms] analysis end time

%% calculating VS and SAC
disp('calculating PH');
[PH_D50,PHtv_D50,VS_D50] = calcPhaseHist(SPin,T1_D50,T2_D50,NB,F);
[PH_D40,PHtv_D40,VS_D40] = calcPhaseHist(SPin,T1_D40,T2_D40,NB,F);
[PH_D30,PHtv_D30,VS_D30] = calcPhaseHist(SPin,T1_D30,T2_D30,NB,F);
[PH_D20,PHtv_D20,VS_D20] = calcPhaseHist(SPin,T1_D20,T2_D20,NB,F);

disp('calculating SAC');
[SAC_D50,SACtv_D50,CI_D50] = calcSAC(SPin,BW,T1_D50,T2_D50,TL);
[SAC_D40,SACtv_D40,CI_D40] = calcSAC(SPin,BW,T1_D40,T2_D40,TL);
[SAC_D30,SACtv_D30,CI_D30] = calcSAC(SPin,BW,T1_D30,T2_D30,TL);
[SAC_D20,SACtv_D20,CI_D20] = calcSAC(SPin,BW,T1_D20,T2_D20,TL);

%% theoretical values
VSthr = besseli(1,K) ./ besseli(0,K);
CIthr = besseli(0,2*K) ./ besseli(0,K).^2; 
vsfun = @(x)(besseli(1,x) ./ besseli(0,x) - VS);
SACest = besseli(0,2*K*cos(pi*F*SACtv_D50/1000)) ./ besseli(0,K).^2; 

%% decay factor
% 50ms
SACdecay_D50 = ones(1,length(SACtv_D50));
SACdecay_D50(SACtv_D50<0) = 1 + SACtv_D50(SACtv_D50<0)/(T2_D50-T1_D50);
SACdecay_D50(SACtv_D50>0) = 1 - SACtv_D50(SACtv_D50>0)/(T2_D50-T1_D50);

% 40ms
SACdecay_D40 = ones(1,length(SACtv_D40));
SACdecay_D40(SACtv_D40<0) = 1 + SACtv_D40(SACtv_D40<0)/(T2_D40-T1_D40);
SACdecay_D40(SACtv_D40>0) = 1 - SACtv_D40(SACtv_D40>0)/(T2_D40-T1_D40);

% 30ms
SACdecay_D30 = ones(1,length(SACtv_D30));
SACdecay_D30(SACtv_D30<0) = 1 + SACtv_D30(SACtv_D30<0)/(T2_D30-T1_D30);
SACdecay_D30(SACtv_D30>0) = 1 - SACtv_D30(SACtv_D30>0)/(T2_D30-T1_D30);

% 20ms
SACdecay_D20 = ones(1,length(SACtv_D20));
SACdecay_D20(SACtv_D20<0) = 1 + SACtv_D20(SACtv_D20<0)/(T2_D20-T1_D20);
SACdecay_D20(SACtv_D20>0) = 1 - SACtv_D20(SACtv_D20>0)/(T2_D20-T1_D20);

%% plotting
figure(1);
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Position', [450 60 560*1.0 420*2.0]);

% phase histogram
% subplot(2,1,1); cla; hold on;
% plot(PHtv,PH,'b-'); 
% xlim([0,1]); ylim([0,max(PH)*1.2]);
% text(0.1,max(PH)*1.12,sprintf('VSthr = %.4f',VSthr));
% text(0.1,max(PH)*1.06,sprintf('VSout = %.4f',VS));
% text(0.1,max(PH)*1.00,sprintf('Nspikes = %d',sum(PH)));

% SAC curve
subplot(1,2,1); cla; hold on;
plot(SACtv_D50,SACest,'r-'); % estimated SAC (without decay factor, D=50)
plot(SACtv_D50,SAC_D50,'b-'); % calculated SAC (D=50)
plot(SACtv_D50,max(SACest).*SACdecay_D50,'b:'); % theo decay (D=50)
plot(SACtv_D40,SAC_D40,'g-'); % calculated SAC (D=40)
plot(SACtv_D40,max(SACest).*SACdecay_D40,'g:'); % theo decay (D=40) 
% factorxlim([-TL,TL]); ylim([0, max(SAC)*1.3]);
text(-8,max(SAC_D50)*1.24,sprintf('CIthr = %.4f',CIthr));
text(-8,max(SAC_D50)*1.16,sprintf('CIout = %.4f',CI_D50));

% subplot 2
subplot(1,2,2); cla; hold on;
plot(SACtv_D30,SACest,'r-'); % estimated SAC (without decay factor, D=30)
plot(SACtv_D30,SAC_D30,'b-'); % calculated SAC (D=30)
plot(SACtv_D30,max(SACest).*SACdecay_D30,'b:'); % theo decay (D=30)
plot(SACtv_D20,SAC_D20,'g-'); % calculated SAC (D=20)
plot(SACtv_D20,max(SACest).*SACdecay_D20,'g:'); % theo decay (D=20) 
% factorxlim([-TL,TL]); ylim([0, max(SAC)*1.3]);
text(-8,max(SAC_D30)*1.24,sprintf('CIthr = %.4f',CIthr));
text(-8,max(SAC_D30)*1.16,sprintf('CIout = %.4f',CI_D30));
% generate PDF/PNG figs
%print('-dpdf', '-r1200', 'decay.pdf');
%print('-dpng', '-r300', 'decay.png');

