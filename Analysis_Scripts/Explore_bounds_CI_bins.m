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
figure(1)
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
figure(2)
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
