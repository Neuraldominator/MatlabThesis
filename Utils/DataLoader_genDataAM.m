function [C] = DataLoader_genDataAM(folderpath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Re-structures the separate raw ANmodel generated data files (amplitude-
% modulated) in the target directory.
% 
% Example:
% >> C = DataLoader_genData("..\Source_Code\ANmodel\ANmod\")
% 
% The output cell C is a Nx5 cell array, where N is the number of data
% files. The i-th row of the cell contains (in order): binary spike trains
% (800x20000), decibel level [db SPL], carrier frequency [Hz], time vector
% [ms] and envelope modulation frequency [Hz].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
%   - folderpath (char): the path of the desired folder. The function 
%                        assumes your pwd to be the folder
%                        "Analysis_Scripts". Please adjust "folderpath"
%                        input accordingly. It is important that the paths
%                        have a "\" at the end. The data in the "ANmod"
%                        folder contains the following variables (in
%                        order): binary spike trains, decibel level [db
%                        SPL], carrier frequency [Hz], envelope modulation
%                        frequency [Hz], stimulus sound waveform, time
%                        vector [ms] and relative transmembrane potential
%                        of IHC in [V].
%
% Output:
%   - C (cell): Nx5 cell array. The i-th row contains the variables (in 
%               order): binary spike trains (800x20000), decibel level 
%               [db SPL], carrier frequency [Hz], time vector [ms], and 
%               envelope modulation frequency [Hz].
%                        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler (Dec 2020)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

id = "*.mat" ;
% load all .mat files from the directory
s = dir(folderpath + id);   

% number of files in current folder
Nfiles = size(s, 1);    

C = cell(Nfiles, 5);  % pre-alloc.
for idx_file = 1:Nfiles
    % load the .mat file as a data struct d
    filepath = folderpath + s(idx_file).name;
    d = load(filepath);  
    
    % create advantageous data structure
    temp = struct2cell(d)';
    C(idx_file, :) = horzcat(temp(1), temp(3), temp(2), temp(6), temp(4));
end

end  % [eof]