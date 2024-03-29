%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script can be used to generate spike data with the von Mises
% distribution. Time-dependent firing probabilities are converted to spikes
% with the Poisson process. The data will be stored in a struct gen_data 
% with the fieldname "mmmdd_yyyy". This field contains a {N x 11} cell 
% array where N is the number of "different" datasets. These datasets were 
% generated from a range of desired vector strength values, e.g.
% VSin=0.05:0.02:0.95 (i.e. N=46). Each of the 11 cell columns represents 
% one parameter of the datasets for the N different vector sizes, that the 
% data is based on. The order in which these parameters are stored in the 
% columns is: spike trains, depvar, frequency, epoch, durat, delay, cutoff,
% (input) spike rate, (empirical) total number of spikes, VSin, and
% concentration parameter kappa (von Mises). Ideally, when additional data
% is generated, it is saved into the same struct with a new field, 
% indicating the date of generation.
%
% Alt.: fieldname = strcat(VSin, strjoin(strsplit(string(VSin(k)), '.')), '');

%% 1. Add path to Ashida's Code 

path_GenData = strcat('C:\Users\Dominik\Documents\Uni_Oldenburg\', ...
    '5th_semester\MasterThesis\MatlabThesis\Gen_Data');
cd(path_GenData)

path1 = "../Source_Code/Ashida_2020_code/decay";
addpath(path1)
path2 = "../Source_Code/Ashida_2020_code/invivo";
addpath(path2)


%% 2. Define generation parameters
VSin = 0.05:0.02:0.95;  
VSin_batch1 = VSin(1:length(VSin)/2);  % split due to memory
VSin_batch2 = VSin(length(VSin)/2 + 1:end);  % split due to memory
dt = 2;  % Time step [us]
D = 150;  % Duration [ms] (-> time steps N = D/dt = 75000)
M = 400;  % number trials/repetitions
F = 500;  % Frequency [Hz]
L = 200;  % spike rate [spikes/sec]
P = 0;  % initial phase [rad] 


%% 3. Generate the phase-locked spike trains with PhaseLock.m for batch 1
% convert time steps from [us] to [ms]
DT = dt/1000;  

% number of simulated time steps 
N = D/DT; 

% number of "sessions"
Nsess = length(VSin); 
N_batch = length(VSin_batch1);

% init. spike train (in batches due to memory limit)
A = zeros(N_batch, M, N);

% init. kappa
K = zeros(N_batch, 1);
for k = 1:N_batch
    [A(k,:,:), K(k)] = PhaseLock(M, N, F, VSin_batch1(k), L, P, DT);
end

%% 4. Create the data struct
gen_data = struct;  % struct with one field

C = cell(N_batch, 11); % init field content
for k = 1:N_batch
    
    % convert binary spikes in A into spike times with temp. resolution DT
    for l = 1:M
        TSP{l} = find(A(k,l,:)==1)*DT;  % spike times in [ms] 
    end
    
    % filling the cell array
    C{k, 1} = TSP;  % spike trains
    C{k, 2} = NaN;  % depvar (not needed in this data)
    C{k, 3} = F;  % freq
    C{k, 4} = D;  % epoch = duration 
    C{k, 5} = D;  % durat = duration
    C{k, 6} = 0;  % delay = 0
    C{k, 7} = 0;  % cutoff = 0
    C{k, 8} = L;  % spike rate    
    C{k, 9} = sum(cellfun(@numel, TSP));  % total number of spikes
    C{k, 10} = VSin_batch1(k);  % VS value which the spike trains are generated from
    C{k, 11} = K(k);  % concentration parameter
end

gen_data = setfield(gen_data, 'batch1', C);
save('Raw_GenData/gen_data.mat', 'gen_data');
clc;

%% 5. Generate the phase-locked spike trains with PhaseLock.m for batch 2
N_batch = length(VSin_batch2);

A = zeros(N_batch, M, N);  % init. spike trains
K = zeros(N_batch, 1);  % init. kappa
for k = 1:N_batch
    [A(k,:,:), K(k)] = PhaseLock(M, N, F, VSin_batch2(k), L, P, DT);
end

%% 6. Expand the existing data struct by a field "batch2"
C = cell(N_batch, 11); % init field content
for k = 1:N_batch
    
    % convert binary spikes in A into spike times with temp. resolution DT
    for l = 1:M
        TSP{l} = find(A(k,l,:)==1)*DT;  % spike times in [ms] 
    end
    
    % filling the cell array
    C{k, 1} = TSP;  % spike trains
    C{k, 2} = NaN;  % depvar (not needed in this data)
    C{k, 3} = F;  % freq
    C{k, 4} = D;  % epoch = duration 
    C{k, 5} = D;  % durat = duration
    C{k, 6} = 0;  % delay = 0
    C{k, 7} = 0;  % cutoff = 0
    C{k, 8} = L;  % spike rate    
    C{k, 9} = sum(cellfun(@numel, TSP));  % total number of spikes
    C{k, 10} = VSin_batch2(k);  % VS value which the spike trains are generated from
    C{k, 11} = K(k);  % concentration parameter
end

gen_data = setfield(gen_data, 'batch2', C);


%% 7. Save the concatenated data as a .mat file
fieldname = 'dec6_2020';

% concatenate the data
gen_data = setfield(gen_data, fieldname, [gen_data.batch1; gen_data.batch2]);

% remove the fields 'batch1' and 'batch2'
gen_data = rmfield(gen_data, 'batch1');
gen_data = rmfield(gen_data, 'batch2');

% save the final data struct in the file "gen_data.mat"
save('Raw_GenData/gen_data.mat', 'gen_data');

% The empirical spike rate can be calculated with C{9}/C{5}




