function [data, Rout] = PreprocessingSpikes(foldername, R_thresh, Nsp_thresh, cutoff)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Truncates the spike trains from those sessions of the raw spike data,
% which have a higher driven spike rate than R_tresh. The truncation window
% is given by [delay + cutoff, delay + durat].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input: 
%  foldername (str)   : struct with fields based on animal and cell type with
%                       the recorded spike trains. 
%  R_thresh (double)  : spike rate threshold in [sp/sec], default is 30. All
%                       sessions with a spike rate below R_thresh are removed
%  Nsp_thresh (double): filtering threshold for the number of spikes, default 
%                       is 400.
%  cutoff (double)    : onset cutoff time [ms] after stimulation. Default is 
%                       15.
%
% Output: 
%  data (struct): struct with fields based on animal and cell type with the 
%                 cleansed spike trains. Order of cell entries: spikes, 
%                 depvar, freq, epoch, durat, delay, cutoff, "driven
%                 spike rate" and "total number of spikes".
%  Rout (struct): struct with fields representing the animal/ cell types.  
%                 For each session (in cell) of a field, the driven spike 
%                 rate is calculated from all non-spontaneous trials during
%                 the time of stimulation [delay + cutoff, delay + duration]
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler, Nov 2020 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set default values
if nargin < 2
    R_thresh = 30;
end

if nargin < 3
    Nsp_thresh = 400;
end

if nargin < 4
    cutoff = 15;
end

% load the data from the specified folders in foldername
spike_data = SpikeDataLoader(foldername);

% field names of spike_data struct
fields = fieldnames(spike_data);  

% number of folders
n_folder = length(fields);  

% init. output structs
data = spike_data; 
Rout = struct();  

for folder = 1:n_folder
    % get all recordings from one animal and one cell type
    sp = getfield(data, fields{folder});  
    
    % number of sessions
    n_sessions = length(sp);
    
    % init. outputs for current folder
    session_cell = cell(1, 8); 
    Rout_session = zeros(n_sessions, 1); 
    Nsp_session = zeros(n_sessions, 1);
    
    % init. counters for while loop
    session = 1; 
    non_empty_session = 1;  % counter for the filtered sessions 
    
    while session <= n_sessions
        % get the "session specifics"
        sp_session = sp{session}{1};      % spikes of the current session
        depvar_session = sp{session}{2};  % depvar of the current session
        durat = sp{session}{5};           % duration of the current session
        delay = sp{session}{6};           % delay of the current session
        
        % get all non-spontaneous trials and update the depvar vector
        sp_driven = sp_session(~isTrialSpontaneous(depvar_session));
        dv_driven = depvar_session(~isTrialSpontaneous(depvar_session));
        
        % truncate the non-spontaneous trials
        T1 = delay + cutoff;  % cut off the onset response 
        T2 = delay + durat;  % end of stimulation time
        SpikeTrainTruncWrapper = @(SPin) SpikeTrainTruncator(SPin, T1, T2);
        trunc_sp = cellfun(SpikeTrainTruncWrapper, sp_driven, ...
                           'UniformOutput', false);  
        
        % total number of spikes for truncated spike trains 
        [Rout_session(session), Nsp_session(session), ~] = ...
            GetSpikeRate(trunc_sp, T2-T1); 
        
        
        % apply the filtering
        if Rout_session(session) >= R_thresh && ...
                Nsp_session(session) >= Nsp_thresh
            % storage
            session_cell{non_empty_session, 1} = trunc_sp;  
            session_cell{non_empty_session, 2} = dv_driven;
            session_cell{non_empty_session, 3} = sp{session}{3}; 
            session_cell{non_empty_session, 4} = sp{session}{4}; 
            session_cell{non_empty_session, 5} = sp{session}{5};
            session_cell{non_empty_session, 6} = sp{session}{6};
            session_cell{non_empty_session, 7} = cutoff;
            session_cell{non_empty_session, 8} = Rout_session(session);
            session_cell{non_empty_session, 9} = Nsp_session(session);
            
            % increase "filtered sessions" counter
            non_empty_session = non_empty_session + 1;
        end
        
        % increase "session iteration" counter
        session = session + 1;
        
    end    

    % update all sessions for current folder in the current folder field
    data = setfield(data, fields{folder}, session_cell);
    Rout = setfield(Rout, fields{folder}, Rout_session);

end

end % [eof]


%--------------------------------------------------------------------------
function B = isTrialSpontaneous(depvar)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Returns true if depvar is -6666 and false otherwise.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input: 
%  depvar (double): stimulus parameter (-6666 indicates spontaneous 
%                   response = no stimulus)
%
% Output: 
%  B (boolean): true if trial is spontaneous; false otherwise.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler, Nov 2020 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
B = depvar == -6666;

end  %[eof]


%--------------------------------------------------------------------------
function SPout = SpikeTrainTruncator(SPin, T1, T2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Truncate the spike train to the analysis window [T1, T2].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input: 
%  SPin (double): spike train [ms]
%  T1 (double): start of truncation [ms]
%  T2 (double): end of truncation [ms]
%
% Output: 
%  SPout (double): truncates spike train [ms]
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler, Nov 2020 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
SPout = SPin((SPin >= T1) & (SPin <= T2)); 

end  %[oef]


%--------------------------------------------------------------------------
function [R, Nsp, N] = GetSpikeRate(SPin, durat)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Truncate the spike train to the analysis window [T1, T2].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input: 
%  SPin (cell)   : cell array containing spike trains [ms].
%  durat (double): duration of analysis [ms] 
%
% Output: 
%  R (double)  : Spike Rate [sp/sec]
%  Nsp (double): Number of total spikes.
%  N (double)  : Number of trials/ spike trains
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by Dominik Kessler, Nov 2020 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% total number of spikes for truncated spike trains 
Nsp = sum(cellfun(@numel, SPin)); 

% total number of non-spontaneous trials of the session
N = numel(SPin);

% calculate the "driven spike rate" of the current session in [spikes/sec]
R = 1000 * Nsp / (durat * N); 
end  %[eof]