function [p,CI,r] = SACnoise_peakSign_tytol(spikes)

burst_times = [0 1000; 1200 2200];
CorBinWidth = 0.02; % use 20 us window of coincidence
BS_reps = 1000; % number of bootstrap repetitions, at least 500
p = []; CI = []; r = [];

for i = 1:length(burst_times)
    Tspikes = {};
    reps = length(spikes);
    Nspik = [];
    cnt = 0;
    for j = 1:reps
        temp = spikes{1,j};
        temp = temp(temp >= burst_times(i,1));
        temp = temp(temp <= burst_times(i,2));
        if ~isempty(temp) && length(temp)>5
        cnt=cnt+1;
        Tspikes{1,cnt} = temp;
        Nspik = [Nspik length(temp)];
        end
    end
    Dur = burst_times(i,2)-burst_times(i,1);
    [p(i), BinCenters, ~, ~, Nco, Spt_Nco] = sacpeaksign(Tspikes, CorBinWidth, BS_reps, Dur);
    r(i) = sum(Nspik)/(Dur * cnt);
    
    % Joris et al 2006: CI = Nc/ M(M-1)r^2.w.D
    CI(i) = Spt_Nco / (cnt*(cnt-1)*r(i)^2*CorBinWidth*Dur);

    figure;
    histogram(Nco,BinCenters)
    hold on
    plot([Spt_Nco Spt_Nco],[0 5],'r','LineWidth',2)
    xlabel('Number of coincidences (Nco)')
    ylabel('Count')
    title(sprintf('noise burst %d, p = %0.2f, CI = %0.2f',i,p(i),CI(i)))
    legend('Bootstrap results','Experimental Nco','Location','northeast')
    set(gca,'FontSize',18)
end
