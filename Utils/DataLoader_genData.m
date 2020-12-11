function [raw_data] = DataLoader_genData(folderpath, db, celltype)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Re-structures the separate raw (artifical or generated) data files in 
% the target directory.
% 
% Example:
% >> D = DataLoader_genData("..\Source_Code\ANmodel\GBCdata\", 40, "GBC")
% 
% This will output a struct D with the fieldname GBCdata40db, containing 
% a Nx4 cell array, where N is the number of data files. The first row of
% the cell contains (in order) the binary spike train, the db level of the 
% experiment, the frequency [Hz] of the experiment and the time vector [ms]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
%   - folderpath (char): the path of the desired folder. The function 
%                        assumes your pwd to be the folder 
%                        "Analysis_Scripts". Please adjust "folderpath"
%                        input accordingly. It is important that the
%                        paths have a "\" at the end.
%   - db (double): can be either 40 or 70 (default: 70)
%   - celltype (string): can be either "AN" or "GBC" (default: "GBC")
% 
% Output:
%   - raw_data (struct): struct with one field. The fieldname has the
%                        following pattern "{celltype}"+"data"+"{db}"+"db".
%                        This field contains a Nx4 cell array, which
%                        contains the following variables (in order):
%                        binary spike trains, db level, frequency [Hz], and 
%                        time vector [ms].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler (Dec 2020)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3
    celltype = "BGC";
end

if nargin < 2
    db = 70;
end

raw_data = struct;  % pre-allocation

id = "*" + string(db) + "db*.mat" ;
% load all .mat files from the directory
s = dir(folderpath + id);   

% number of files in current folder
Nfiles = size(s, 1);    

c = cell(Nfiles, 4);  % pre-alloc.
for idx_file = 1:Nfiles
    % load the .mat file as a data struct d
    filepath = folderpath + s(idx_file).name;
    d = load(filepath);  
    
    % 2 different cases
    if celltype == "GBC"  % the GBC data contain 4 variables which are all important
        c(idx_file, :) = struct2cell(d);
    elseif celltype == "AN"  % the AN data contain 6 variables, only the 1st, 2nd, 3rd and 5th are important
        temp = struct2cell(d)';
        c(idx_file, :) = horzcat(temp(1:3), temp(5));
    end
end

% parsing to construct the field name
str = strsplit(folderpath, '\');
cha = convertStringsToChars(str(end-1));    
db_str = string(db) + "db";

% 2 different cases
if celltype == "GBC"
    raw_data = setfield(raw_data, convertCharsToStrings(cha) + db_str, c);
elseif celltype == "AN"
    raw_data = setfield(raw_data, convertCharsToStrings(cha(1:end-1)) + ...
    db_str, c);
end


end  % [eof]