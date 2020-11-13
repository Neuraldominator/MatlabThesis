function [] = FunctionLoader(dir_path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loading all files from the specified folder "dir_path". Current directory
% is set to "Code_Tests". The input path is relative to this folder. This
% function assumes a project folder strucutre as in "3.Matlab".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input: 
%  dir_path (str): path name of the desired directory, e.g. 
%                  "..\Source_Code\Joris_2006_code\".
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler, Nov 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

path_CodeTest = strcat('C:\Users\Dominik\Documents\Uni_Oldenburg\', ...
                       '5th_semester\Project_Paper\3.Matlab\Code_Tests');
cd(path_CodeTest)

% desired directory
addpath(dir_path);

end %[eof]