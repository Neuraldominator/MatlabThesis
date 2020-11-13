%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to plot the effect of bin width BW on SAC/CI 
% May-Oct 2020, Go Ashida (go.ashida@uni-oldenburg.de)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% loading data file
infile = 'CIv60all.mat'; 
load(infile); 

% mean/std of calculated CI
meanCI = mean(CIall,2);
stdCI = std(CIall,0,2);

% estimated CI 
CIest = besseli(0,2*K) ./ besseli(0,K).^2; 

% theoretical CIs (for varied BW)
BWrange = logspace(log10(1),log10(3000),400); % [us]
Norder = 10; % order of decay factors
CIdecay = zeros(Norder,length(BWrange)); % decay factor for BW
for n = 1:Norder
  if(n==1)
   CIoffset = ones(1,length(BWrange)); 
  else
   CIoffset = CIdecay(n-1,:); 
  end
  CIdecay(n,:) =  CIoffset + 2 * ( besseli(n,K)./besseli(0,K) ).^2 ...
                     .* (sin(pi*n*F*BWrange*1e-6)./(pi*n*F*BWrange*1e-6)); 
end


%% CI values for default length and repetition
figure(333);
set(gcf, 'PaperPositionMode', 'auto');
set(gcf, 'Position', [150 120 560*1.5 420*2.0]);

subplot(2,2,1); cla; hold on;
errorbar(BWall, meanCI, stdCI, 'b-'); 
plot([1,2500],[CIest,CIest],'g-'); 
plot(BWrange,CIdecay(10,:),'c-'); 
xlim([1,2500]); ylim([0.9,2.3]); set(gca,'XScale','log'); 
xlabel('SAC bin width W [us]'); ylabel('calculated CI'); 
title(sprintf('all Ws (D = %.0f ms, M = %.0f trials)',Ddef,Mdef));

subplot(2,2,2); cla; hold on;
errorbar(BWall(IDodd), meanCI(IDodd), stdCI(IDodd), 'k-'); 
plot([1,2500],[CIest,CIest],'g-'); 
plot(BWrange,CIdecay(10,:),'c-'); 
xlim([1,2500]); ylim([0.9,2.3]); set(gca,'XScale','log'); 
xlabel('SAC bin width W [us]'); ylabel('calculated CI'); 
title('odd integer W/dt')

subplot(2,2,3); cla; hold on;
errorbar(BWall(IDevn), meanCI(IDevn), stdCI(IDevn), 'm-'); 
plot([1,2500],[CIest,CIest],'g-'); 
plot(BWrange,CIdecay(10,:),'c-'); 
xlim([1,2500]); ylim([0.9,2.3]); set(gca,'XScale','log'); 
xlabel('SAC bin width W [us]'); ylabel('calculated CI'); 
title('even integer W/dt')

subplot(2,2,4); cla; hold on;
errorbar(BWall(IDnon), meanCI(IDnon), stdCI(IDnon), 'r-'); 
plot([1,2500],[CIest,CIest],'g-'); 
plot(BWrange,CIdecay(10,:),'c-'); 
xlim([1,2500]); ylim([0.9,2.3]); set(gca,'XScale','log'); 
xlabel('SAC bin width W [us]'); ylabel('calculated CI'); 
title('non-integer W/dt')

% generate PDF/PNG figs
print('-dpdf', '-r1200', 'binwidthsim.pdf');
print('-dpng', '-r300', 'binwidthsim.png');


