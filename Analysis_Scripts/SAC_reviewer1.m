%% 1. import functions
addpath("..\Source_Code\Ashida_2020_code\invivo")
addpath("..\Source_Code\Ashida_2020_code\decay")

%% 2. generate some random spike train
N = 1000;
F = 500; % freq [hz]
L = 200; % sp rate [hz]
DT = 0.1; % time step [ms]
SPbin = PhaseLock(1, N, F, 0.02, L, 0, DT);

% conversion from binary to spike times
sp = find(SPbin==1)*DT;

%% 3. repeat the random spike train enough times
SPmat = repmat(sp, 400, 1);
for k=1:400
    SPcell{k} = SPmat(k,:);
end

%% 4. Calculate CI
[~,~,CI,~,Nsp] = calcSAC(SPcell,0.05,0,N/DT,5);
