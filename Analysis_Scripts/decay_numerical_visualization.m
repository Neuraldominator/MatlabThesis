%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a demo of the decay of CI with respect to the bin width.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% April 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N     = [1, 2, 3, 4, 5];  % accuracy of the series
kappa = 3;  % concentration parameter of vM distribution
freq  = 1;  % stimulus frequency in [kHz]
w     = 0.005:0.005:0.1;  % bin width in [ms]
S     = ones(1,length(w));  % init
CI    = ones(3,length(w));  % init
for n = 1:N(end)
    harmonic = (besseli(n,kappa) / besseli(0,kappa)).^2;
    decay    = sin(pi .* n .* freq .* w) ./ (pi .* n .* freq .* w);
    S = S + 2 .* harmonic .* decay;
    if any(n == N)
        CI(n==N,:) = S;
    end
end
figure
for n=1:5
    plot(w,CI(n,:), '-o', 'color', rand(1,3))
    hold on
end
xlabel("bin width [ms]")
ylabel("CI")
legend("N=1", "N=2", "N=3", "N=4", "N=5", "Location", "best")
hold off

