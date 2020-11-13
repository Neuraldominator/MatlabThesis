function [A,K] = PhaseLock(M,N,F,R,L,P,DT)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generating phase-locked spike sequences (ver 1.0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input 
%  M: number of input fibers 
%  N: time steps 
%  F: frequency [Hz]
%  R: vector strength (0<=R<=0.96 for a reliable calculation)
%  L: mean rate [spikes/sec] 
%  P: initial phase [rad]
%  DT: time step size [ms] 
% 
% Output: 
%  A: spike vector (M*N matrix)
%  K: concentration parameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tech notes
%  This script generates phase-locked spike sequences using the 
%  Poissonian spike generation algorithm and the von Mises distribution. 
%  For detailed relations between the von Mises distribution and resulting 
%  vector strength, see Ashida et al. (2013) Front Comput Neurosci 7:151  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Revisions
% Created (ver 1.0): Apr 21, 2017 by GA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If no input, return a zero vector of specified length 
if(M==0)
 A = zeros(1,N);
 return; 
end

% Concentration parameter for von Mises distribution
vsfun = @(x)(besseli(1,x) ./ besseli(0,x) - R);
K = fsolve(vsfun,1.0, optimset('Display','off'));

% Spike probability at each step 
X = ( 0:(N-1) ) * ( 2 * pi * F * DT/1000 ) + P; % phase vector
Q =  exp( K * cos(X) ) / besseli(0,K) * ( L * DT/1000 ); % mean spike number per step 
H = Q .* exp(-Q); 

% Generate Poissonian spikes
rmat = rand(M,N); 
A = double( rmat < repmat(H,M,1) ); 
