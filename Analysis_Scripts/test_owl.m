% explore the owl data more
% first, run BinWidthAnalysis_InVivoData.m
% cutoff = 15;
% R_thresh = 30;
% Nsp_thresh = 400;

%% look at the spike rate of all units and the total number of spikes
[data_check, ~] = PreprocessingSpikes("owlNM", R_thresh, Nsp_thresh, cutoff);

%% number of spikes
Nsp = [data_check.owlNM{:,9}]';
Nsp(idx-74)

%% spike rate
R = [data_check.owlNM{:,8}]';
R(idx-74)

%% mean
figure
subplot(121)
plot(meanCI,'o','color','b')
hold on
plot(idx,meanCI(idx),'o','color','r')
xlabel('units')
xlim([0,126])
ylabel('mean CI')
ylim([0,11])
legend("all units","high CV units","Location","northwest")

%% sd
subplot(122)
plot(stdCI,'o','color','b')
hold on
plot(idx,stdCI(idx),'o','color','r')
xlabel('units')
xlim([0,126])
ylabel('std CI')
ylim([0,1])
legend("all units","high CV units","Location","northwest")

%% check frequencies
freq = [data_check.owlNM{:,3}]';

figure
plot(freq,'o','color','b')
hold on
plot(idx-74,freq(idx-74),'o','color','r')
xlabel('units')
xlim([0,52])
ylabel('input frequency [Hz]')
ylim([0,8000])
legend("all units","high CV units","Location","southwest")
