function cleansed_spikes = PreprocessingSpikes(foldername, sr, cutoff)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% deletes empty cells from the raw spike trains. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input 
%  foldername (str): struct with fields based on animal and cell type with
%                    the recorded spike trains. 
%  sr (double)     : minimal spike rate (threshold).
%  cutoff (double) : onset cutoff time [ms] after stimulation.
%
% Output: 
%  cleansed_spikes (struct): struct with fields based on animal and cell 
%                            type with the cleansed spike trains.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler, Nov 2020 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spike_data = RemoveEmptyCells(foldername);

fields = fieldnames(spike_data);  % field names of spike_data struct
n_folder = length(fields);  % number of folders
cleansed_spikes = spike_data;  % init
for folder = 1:n_folder
    % get all recordings from one animal and one cell type
    sp = getfield(cleansed_spikes, fields(folder));  
    
    % for each separate recording, access the spike trains
    n_sessions = length(sp);  % number of sessions
    sp_session_cell = cell(n_sessions, 1);  % init.
    depvar_session_cell = cell(n_sessions, 2);  % init.
    for session = 1:n_sessions
        % get all recordings of the current session
        sp_session = sp{session}{1};  % spikes
        depvar_session = sp{session}{2};  % depvar
        
        % remove empty trials (cells) from current session
        sp_session(~cellfun('isempty', sp_session))  % spikes
        depvar_session(~cellfun('isempty', sp_session))  % depvar

        % for each trial of a session, do the preprocessing
        n_trials = length(sp_session);  % number of trials   
        trial_cell = cell(n_trials, 1);  % init.
        for trial = 1:n_trials
            sp_trial = sp_session{trial};
            
            
            if sp_trial / "recording time" < sr  % spike rate high enough
                % delete the spike train and the corresponding depvar entry
            
            else  % truncate spike train to analysis window
                t0 = Data.delay + cutoff;     % cut off the onset response 
                t1 = Data.delay + Data.durat; % end of stimulation time 
                SPT_no_onset{k} = temp((temp > t0) & (temp < t1)); %truncation
            end
            
            trial_cell(trial) = sp_trial;  % update the changes
        end
        
        sp_session_cell(session) = trial_cell;  % update the changes
        depvar_session_cell(session) = "depvar";
    end
    
    % update all sessions for current folder
    cleansed_spikes = setfield(cleansed_spikes, fields(folder), session_cell);
    
end

end % [eof]