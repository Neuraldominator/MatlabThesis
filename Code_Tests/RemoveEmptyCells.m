function cleansed_spikes = RemoveEmptyCells(foldername)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% deletes empty cells from the raw spike trains. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input 
%  foldername (str): struct with fields based on animal and cell type with
%                    the recorded spike trains. 
%
% Output: 
%  cleansed_spikes (struct): struct with fields based on animal and cell 
%                            type with the cleansed spike trains. Order of 
%                            cell entries: spikes, depvar, freq, epoch, 
%                            durat and delay.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler, Nov 2020 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spike_data = SpikeDataLoader(foldername);

fields          = fieldnames(spike_data);  % field names of spike_data struct
n_folder        = length(fields);          % number of folders
cleansed_spikes = spike_data;              % init

for folder = 1:n_folder
    % get all recordings from one animal and one cell type
    sp = getfield(cleansed_spikes, fields{folder});  
    
    % for each separate recording, access the spike trains
    n_sessions    = length(sp);           % number of sessions
    sessions_cell = cell(n_sessions, 1);  % init.
    
    for session = 1:n_sessions
        % get all recordings of the current session
        sp_session     = sp{session}{1};  % spikes
        depvar_session = sp{session}{2};  % depvar
        
        % remove empty trials (cells) from current session
        sp_session(~cellfun('isempty', sp_session));      % spikes
        depvar_session(~cellfun('isempty', sp_session));  % depvar
        
        % 1x2 cell with spikes and depvar of current session
        sessions_cell{session} = {sp_session, ...
                                  depvar_session, ...
                                  sp{session}{3}, ...
                                  sp{session}{4}, ...
                                  sp{session}{5}, ...
                                  sp{session}{6}};
    end
    
    % update all sessions for current folder
    cleansed_spikes = setfield(cleansed_spikes, fields{folder}, ...
        sessions_cell);
    
end

end % [eof]
