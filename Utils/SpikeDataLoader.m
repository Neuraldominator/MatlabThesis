function spike_data = SpikeDataLoader(foldername)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loading invivo data from specified folders. Assumes a project folder 
% strucutre as in "MatlabThesis".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input: 
%  datafolder (str): folder name of the raw data, e.g. "chickNL". Can be a
%                    D-dimensional string, e.g. ["chickNL", "owlNM"].
%
% Output: 
%  spike_data (struct): data organized in a struct with fieldnames 
%                       according to folder name (e.g. "chickNL"). These 
%                       fields contains cell arrays with spike times and
%                       "depvar". Order of cell entries: spikes, depvar,
%                       freq, epoch, durat and delay.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler, Nov 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% call DataLoader to access raw data
raw_data = DataLoader(foldername);  % number of input folders

% fill in the spike_data struct
spike_data = struct;  % init.
n_folder = length(foldername);  % number of folders 
for idx1 = 1:n_folder
   f = getfield(raw_data, foldername(idx1));  % access current field
   
   n_sp = length(f);  % number of spike data in the current field
   subcell = cell(n_sp, 1);  % init.
   for idx2 = 1:n_sp
       subcell{idx2} = {f{idx2}.spikes, f{idx2}.depvar, f{idx2}.freq, ...
                        f{idx2}.epoch, f{idx2}.durat, f{idx2}.delay}; 
   end
   
   spike_data = setfield(spike_data, foldername(idx1), subcell);
    
end

end %[eof]