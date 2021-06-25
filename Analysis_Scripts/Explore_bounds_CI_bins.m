%% Explore the relative error in the calculation of CI through binning.
% Here, the three parameters kappa, frequency, and bin width are tested
% through a slice-and-dice approach. The relavant parameter combinations
% are limimted by the relation between VS and frequency (or kappa and
% frequency). Therefore, a phenomenological curve was crafted describing
% the maximum VS value dependent on f (Hz). 

%% plot errors
k = 1:7;
f = [200,400,800,1400];  % Hz
N = 100;  % number of summands used
w = 0.001:0.01:0.6;  % bin width [ms]

ci_bins = zeros(length(f),length(k),length(w));
ci_plain = zeros(1,length(k));
for m = 1:length(f)
  for j = 1:length(k)
    ci_plain(j) = besseli(0,2*k(j))/(besseli(0,k(j))^2);
    for i = 1:length(w)
      ci_bins(m, j, i) = CIbin(k(j), w(i), f(m), N);
    end
  end
end

%% plot normalized
f1 = figure(1);
subplot(2,2,1)
col = {[0 0 1],[1 0 0],[0 1 0],[0 1 1],[1 1 0],[1 0 1],[0.5 0.5 0.5]};
for j = 1:length(k)
  plot(w, reshape(ci_bins(1,j,:),1,[]) ./ ci_plain(j),'o-','color',col{j})
  hold on 
end
xlabel('bin width [ms]')
ylabel('CI')
title(sprintf('f=%d Hz',f(1)))

subplot(2,2,2)
col = {[0 0 1],[1 0 0],[0 1 0],[0 1 1],[1 1 0],[1 0 1],[0.5 0.5 0.5]};
for j = 1:length(k)
  plot(w, reshape(ci_bins(2,j,:),1,[]) ./ ci_plain(j),'o-','color',col{j})
  hold on 
end
xlabel('bin width [ms]')
ylabel('CI')
title(sprintf('f=%d Hz',f(2)))

subplot(2,2,3)
col = {[0 0 1],[1 0 0],[0 1 0],[0 1 1],[1 1 0],[1 0 1],[0.5 0.5 0.5]};
for j = 1:length(k)
  plot(w, reshape(ci_bins(3,j,:),1,[]) ./ ci_plain(j),'o-','color',col{j})
  hold on 
end
xlabel('bin width [ms]')
ylabel('CI')
title(sprintf('f=%d Hz',f(3)))

subplot(2,2,4)
col = {[0 0 1],[1 0 0],[0 1 0],[0 1 1],[1 1 0],[1 0 1],[0.5 0.5 0.5]};
for j = 1:length(k)
  plot(w, reshape(ci_bins(4,j,:),1,[]) ./ ci_plain(j),'o-','color',col{j})
  hold on 
end
xlabel('bin width [ms]')
ylabel('CI')
title(sprintf('f=%d Hz',f(4)))
f1.Position = [100 100 540 400];  % set the figure size
set(gca,'TickDir','out');
box off
set(gca,'linewidth',1);
set(gca, 'fontsize', 12);

%% Compute the relative error
idx_vec = zeros(length(f),length(k));
for m = 1:length(f)
  for j = 1:length(k) 
    error_vec = (ci_plain(j) - reshape(ci_bins(m,j,:),1,[])) ./ ci_plain(j);
    idx = find(error_vec > 0.05,1,'first');
    if ~isempty(idx)
      idx_vec(m,j) = idx;
    else
      idx_vec(m,j) = 0;
    end
  end
end

%% plot unnormalized
f2 = figure(2);
subplot(2,2,1)
col = {[0 0 1],[1 0 0],[0 1 0],[0 1 1],[1 1 0],[1 0 1],[0.5 0.5 0.5]};
for j = 1:length(k)
  plot(w, reshape(ci_bins(1,j,:),1,[]),'o-','color',col{j})
  hold on 
  plot([w(1),w(end)], ones(1,2)*ci_plain(j),'--','color',col{j})
end
xlabel('bin width [ms]')
ylabel('CI')
legend('bin (k=1)','k=1','bin (k=2)','k=2','bin (k=3)','k=3',...
    'bin (k=4)','k=4','bin (k=5)','k=5','bin (k=6)','k=6',...
    'bin (k=7)','k=7', 'Location', 'eastoutside')
title(sprintf('f=%d Hz, T=%.2f ms',f(1),1000/f(1)))

subplot(2,2,2)
for j = 1:length(k)
  plot(w, reshape(ci_bins(2,j,:),1,[]),'o-','color',col{j})
  hold on 
  plot([w(1),w(end)], ones(1,2)*ci_plain(j),'--','color',col{j})
end
xlabel('bin width [ms]')
ylabel('CI')
legend('bin (k=1)','k=1','bin (k=2)','k=2','bin (k=3)','k=3',...
    'bin (k=4)','k=4','bin (k=5)','k=5','bin (k=6)','k=6',...
    'bin (k=7)','k=7', 'Location', 'eastoutside')
title(sprintf('f=%d Hz, T=%.2f ms',f(2),1000/f(2)))

subplot(2,2,3)
for j = 1:length(k)
  plot(w, reshape(ci_bins(3,j,:),1,[]),'o-','color',col{j})
  hold on 
  plot([w(1),w(end)], ones(1,2)*ci_plain(j),'--','color',col{j})
end
xlabel('bin width [ms]')
ylabel('CI')
legend('bin (k=1)','k=1','bin (k=2)','k=2','bin (k=3)','k=3',...
    'bin (k=4)','k=4','bin (k=5)','k=5','bin (k=6)','k=6',...
    'bin (k=7)','k=7', 'Location', 'eastoutside')
title(sprintf('f=%d Hz, T=%.2f ms',f(3),1000/f(3)))

subplot(2,2,4)
for j = 1:length(k)
  plot(w, reshape(ci_bins(4,j,:),1,[]),'o-','color',col{j})
  hold on 
  plot([w(1),w(end)], ones(1,2)*ci_plain(j),'--','color',col{j})
end
xlabel('bin width [ms]')
ylabel('CI')
legend('bin (k=1)','k=1','bin (k=2)','k=2','bin (k=3)','k=3',...
    'bin (k=4)','k=4','bin (k=5)','k=5','bin (k=6)','k=6',...
    'bin (k=7)','k=7', 'Location', 'eastoutside')
title(sprintf('f=%d Hz, T=%.2f ms',f(4),1000/f(4)))
f2.Position = [100 100 540 400];  % set the figure size
set(gca,'TickDir','out');
box off
set(gca,'linewidth',1);
set(gca, 'fontsize', 12);

%% max VS approach
F = 200:100:5000;
%F = logspace(2,4,55);  % frequencies [Hz]
%F = F(1:end-5);
NF = length(F);

w = 0.01:0.01:0.15;
NW = length(w);

% calculate max VS from the frequencies
VSf_fun = @(f) min([0.9860, 0.91 / (1+exp((f-3500)/900)) + 0.15 / (1+exp((f-1000)/900))]);

VS = zeros(1, NF);
Kappa = zeros(1, NF);
CIbins = zeros(NW, NF);
CItheo = zeros(1, NF);
Error =  zeros(NW, NF);
for k = 1:NF
  % get the corresponding VS values from F
  VS(k) = VSf_fun(F(k));
  
  % estimate kappa from VS
  VSk_fun = @(x) besseli(1,x) ./ besseli(0,x) - VS(k);
  Kappa(k) = fsolve(VSk_fun, 1.0, optimset('Display','off', 'TolFun',1e-8)); 
    
  % get CI from binning
  CItheo(k) = besseli(0,2*Kappa(k)) ./ besseli(0,Kappa(k))^2;
  
  for j = 1:NW
    CIbins(j,k) = CIbin(Kappa(k), w(j), F(k), 100);
    Error(j,k) = (CItheo(k) - CIbins(j,k)) ./ CItheo(k);
  end  

end

%% Error against kappa (iso-winwidth)
f3 = figure(3);
for j = 1:NW
  if mod(j,3) == 0 || mod(j,5) == 0
  plot(Kappa,Error(j,:),'o-')
  hold on
  end
end
xlabel("Kappa")
ylabel("Relative Error")
xlim([0, 36])
legend("w="+string(w(3)),"w="+string(w(5)),"w="+string(w(6)),...
    "w="+string(w(9)),"w="+string(w(10)),"w="+string(w(12)),...
    "w="+string(w(15)), 'Location','best')
%legend('w=0.03ms','w=0.06ms','w=0.09ms','w=0.12ms','w=0.15ms','Location','best')
f3.Position = [100 100 540 400];  % set the figure size
set(gca,'TickDir','out');
box off
set(gca,'linewidth',1);
set(gca, 'fontsize', 12);

%% Error against frequency (iso-winwidth)
f4 = figure(4);
for j = 1:NW
  if mod(j,3) == 0 || mod(j,5) == 0
  semilogx(F,Error(j,:),'o-')
  hold on
  end
end
%plot(F,Error(5,:),'o-')
xlabel("Frequency (Hz)")
ylabel("Relative Error")
xlim([100, 5000])
legend("w="+string(w(3)),"w="+string(w(5)),"w="+string(w(6)),...
    "w="+string(w(9)),"w="+string(w(10)),"w="+string(w(12)),...
    "w="+string(w(15)), 'Location','best')
%legend('w=0.03ms','w=0.06ms','w=0.09ms','w=0.12ms','w=0.15ms',...
%    'w=0.05ms','Location','best')
f4.Position = [100 100 540 400];  % set the figure size
set(gca,'TickDir','out');
box off
set(gca,'linewidth',1);
set(gca, 'fontsize', 12);

%% Error against bin width (iso-kappa)
f5 = figure(5);
for k = 1:NF
  if mod(k,7) == 0
    %sprintf('k=%d',k)
    plot(w, Error(:,k), 'o-')
    hold on
  end
end
xlabel("bin width (ms)")
ylabel("Relative Error")
legend("K="+string(round(Kappa(7),2)),"K="+string(round(Kappa(14),2)),...
    "K="+string(round(Kappa(21),2)),"K="+string(round(Kappa(28),2)),...
    "K="+string(round(Kappa(35),2)),"K="+string(round(Kappa(42),2)),...
    "K="+string(round(Kappa(49),2)), 'Location','best')
f5.Position = [100 100 540 400];  % set the figure size
set(gca,'TickDir','out');
box off
set(gca,'linewidth',1);
set(gca, 'fontsize', 12);
