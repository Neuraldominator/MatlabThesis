% analyze the distribution of repetitions in the in vivo units.
% run the first two sections of InVivoAnalysis.m first.

c1 = cellfun('length',spike_data.gatorNL(:,1))';
c2 = cellfun('length',spike_data.gatorNM(:,1))';
c3 = cellfun('length',spike_data.chickNM(:,1))';
c4 = cellfun('length',spike_data.chickNL(:,1))';
c5 = cellfun('length',spike_data.owlNM(:,1))';

call = [c1,c2,c3,c4,c5];

ucall = unique(call);

counts = zeros(1,length(ucall));
for idx = 1:length(ucall)
    val = ucall(idx);
    counts(idx) = sum(call==val);
end

figure
plot(ucall, counts)