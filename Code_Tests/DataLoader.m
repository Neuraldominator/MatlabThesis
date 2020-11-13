function raw_data = DataLoader(foldername)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loading invivo data from specified folders. Assumes a project folder 
% strucutre as in "3.Matlab".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input: 
%  datafolder (str): folder name of the raw data, e.g. "chickNL". Can be a
%                    D-dimensional string, e.g. ["chickNL", "owlNM"].
%
% Output: 
%  raw_data (cell): data organized in a cell array. Each cell contains a 
%                   struct with the relevant data. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler, Nov 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% raw data
D = length(foldername);  % number of input folders
raw_data = struct;
idx1 = 1;
while idx1 <= D
    % get struct from dir() for relevant .mat files in target folder 
    %path = "..\Raw_Data\" + foldername(idx1) + "\";
    path = strcat('C:\Users\Dominik\Documents\Uni_Oldenburg\5th_semester', ...
        '\MasterThesis\MatlabThesis\Raw_Data\', foldername(idx1), "\");
    cd(path)
    s = dir(path + '*.mat');    
    
    % Get the files' content as structs and put them in cell array            
    c = cell(length(s), 1);  % pre-allocation
    idx2 = 1;
    while idx2 <= length(s)
        d = load(s(idx2).name);
        c{idx2} = d;
        idx2 = idx2 + 1;
    end
    
    raw_data = setfield(raw_data, foldername(idx1), c);
    idx1 = idx1 + 1;

end

% change directory back to Code_Tests
path = strcat('C:\Users\Dominik\Documents\Uni_Oldenburg\', ...
              '5th_semester\MasterThesis\MatlabThesis\Code_Tests\');
cd(path)

end %[eof]



