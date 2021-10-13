%% plot errors
k = 1:7;
f = [200,400,800,1400];  % Hz
N = 100;  % number of summands used
w = 0.001:0.01:0.6;  % bin width [ms]

% ci_bins is a (#freq x #kappa x #bins) array
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
%subplot(4,1,1)
col = {[0 0 1],[1 0 0],[0 1 0],[0 1 1]};
for j = 1:length(f)
  plot(w*f(j), reshape(ci_bins(j,1,:),1,[]) ./ ci_plain(1),'o-','color',col{j})
  hold on 
end
xlabel('w*f')
ylabel('CI')
ylim([0.2 1])
title(sprintf('kappa=%d',k(1)))
legend('f=200','f=400','f=800','f=1200','Location', 'southwest')
f1.Position = [100 100 400 230];  % set the figure size
set(gca,'TickDir','out');
box off
set(gca, 'linewidth', 1);
set(gca, 'fontsize', 12);

%%
f2 = figure(2);
col = {[0 0 1],[1 0 0],[0 1 0],[0 1 1]};
for j = 1:length(f)
  plot(w*f(j), reshape(ci_bins(j,2,:),1,[]) ./ ci_plain(2),'o-','color',col{j})
  hold on 
end
xlabel('w*f')
ylabel('CI')
ylim([0.2 1])
title(sprintf('kappa=%d',k(2)))
legend('f=200','f=400','f=800','f=1200', 'Location', 'southwest')
f2.Position = [100 100 400 230];  % set the figure size
set(gca,'TickDir','out');
box off
set(gca, 'linewidth', 1);
set(gca, 'fontsize', 12);
%%
f3 = figure(3);
col = {[0 0 1],[1 0 0],[0 1 0],[0 1 1]};
for j = 1:length(f)
  plot(w*f(j), reshape(ci_bins(j,3,:),1,[]) ./ ci_plain(3),'o-','color',col{j})
  hold on 
end
xlabel('w*f')
ylabel('CI')
ylim([0.2 1])
title(sprintf('kappa=%d',k(3)))
legend('f=200','f=400','f=800','f=1200', 'Location', 'southwest')
f3.Position = [100 100 400 230];  % set the figure size
set(gca,'TickDir','out');
box off
set(gca, 'linewidth', 1);
set(gca, 'fontsize', 12);
%%
f4 = figure(4);
col = {[0 0 1],[1 0 0],[0 1 0],[0 1 1]};
for j = 1:length(f)
  plot(w*f(j), reshape(ci_bins(j,4,:),1,[]) ./ ci_plain(4),'o-','color',col{j})
  hold on 
end
xlabel('w*f')
ylabel('CI')
ylim([0.2 1])
title(sprintf('kappa=%d',k(4)))
legend('f=200','f=400','f=800','f=1200', 'Location', 'southwest')
f4.Position = [100 100 400 230];  % set the figure size
set(gca,'TickDir','out');
box off
set(gca, 'linewidth', 1);
set(gca, 'fontsize', 12);

%% plot normalized
f1 = figure(5);
%subplot(4,1,1)
col = {[0 0 1],[1 0 0],[0 1 0],[0 1 1]};
for j = 1:length(f)
  plot(w*f(j), reshape(ci_bins(j,5,:),1,[]) ./ ci_plain(5),'o-','color',col{j})
  hold on 
end
xlabel('w*f')
ylabel('CI')
ylim([0.2 1])
title(sprintf('kappa=%d',k(5)))
legend('f=200','f=400','f=800','f=1200', 'Location', 'southwest')
f1.Position = [100 100 400 230];  % set the figure size
set(gca,'TickDir','out');
box off
set(gca, 'linewidth', 1);
set(gca, 'fontsize', 12);

%% plot normalized
f1 = figure(6);
%subplot(4,1,1)
col = {[0 0 1],[1 0 0],[0 1 0],[0 1 1]};
for j = 1:length(f)
  plot(w*f(j), reshape(ci_bins(j,6,:),1,[]) ./ ci_plain(6),'o-','color',col{j})
  hold on 
end
xlabel('w*f')
ylabel('CI')
ylim([0.2 1])
title(sprintf('kappa=%d',k(6)))
legend('f=200','f=400','f=800','f=1200', 'Location', 'southwest')
f1.Position = [100 100 400 230];  % set the figure size
set(gca,'TickDir','out');
box off
set(gca, 'linewidth', 1);
set(gca, 'fontsize', 12);

%% plot normalized
f1 = figure(7);
%subplot(4,1,1)
col = {[0 0 1],[1 0 0],[0 1 0],[0 1 1]};
for j = 1:length(f)
  plot(w*f(j), reshape(ci_bins(j,7,:),1,[]) ./ ci_plain(7),'o-','color',col{j})
  hold on 
end
xlabel('w*f')
ylabel('CI')
ylim([0.2 1])
title(sprintf('kappa=%d',k(7)))
legend('f=200','f=400','f=800','f=1200', 'Location', 'southwest')
f1.Position = [100 100 400 230];  % set the figure size
set(gca,'TickDir','out');
box off
set(gca, 'linewidth', 1);
set(gca, 'fontsize', 12);