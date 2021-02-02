%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code computes the estimated CI from 6 VS values. These values are
% needed for Figure 2B and Figure 4B+E+H of the ARO poster.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VS = [0.3, 0.62, 0.91, 0.34, 0.87, 0.74];

%% Concentration parameter for von Mises distribution
Ndata = length(VS);
Kvs = zeros(Ndata, 1);
CItheo = zeros(Ndata, 1);
for k = 1:Ndata
    % go from VS to estimated CI
    vsfun = @(K)(besseli(1,K) ./ besseli(0,K) - VS(k));
    Kvs(k) = fsolve(vsfun, 1.0, optimset('Display','off'));
    CItheo(k) = besseli(0,2*Kvs(k)) ./ (besseli(0,Kvs(k))^2);
end
