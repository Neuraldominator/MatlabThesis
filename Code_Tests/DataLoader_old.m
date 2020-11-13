function d = DataLoader_old(foldername)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loading invivo data from specified folders. Assumes a project folder 
% strucutre as in "3.Matlab".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input: 
%  datafolder (str): folder name of the raw data, e.g. "chickNL". Can be a
%                    D-dimensional string, e.g. ["chickNL", "owlNM"].
%
% Output: 
%  d (cell): data organized in a cell array. Each cell contains a struct
%            with the relevant data. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler, Nov 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

path_CodeTest = strcat('C:\Users\Dominik\Documents\Uni_Oldenburg\', ...
                       '5th_semester\Project_Paper\3.Matlab\Code_Tests');
cd(path_CodeTest)

% raw data
D = length(foldername);  % number of input folders
d = cell(D, 1);  % init cell 
idx = 1;
while idx <= D
    path = "..\Raw_Data\" + foldername(idx) + "\";
    d(idx) = {dir(path + '*.mat')};
    idx = idx + 1;
end

end %[eof]



