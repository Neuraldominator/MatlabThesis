function [] = FunctionLoader(dir_path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loading all files from the specified folder "dir_path". Current directory
% is set to "Analysis_Scripts". The input path is relative to this folder.
% This function assumes a project folder strucutre as in "MatlabThesis".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input: 
%  dir_path (str): path name of the desired directory, e.g. 
%                  "..\Source_Code\Joris_2006_code\".
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler, Nov 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set current directory
path_CodeTest = strcat('C:\Users\Dominik\Documents\Uni_Oldenburg\', ...
    '5th_semester\MasterThesis\MatlabThesis\Analysis_Scripts');
cd(path_CodeTest)

% desired directory
addpath(dir_path);

end %[eof]