function S = CollectInStruct(varargin);
% CollectInStruct - collect variables in struct
%   CollectInStruct(X,Y,...) is s struct with field names 
%   'X', 'Y', ... and respective field values X,Y,...
%   All arguments must be variables, not anonymous values.
%
% input: example for function calling: CollectInStruct(var1,var2,var3)
%
%   See also STRUCT, FIELDNAMES, GETFIELD, SETFIELD.
Nvar = length(varargin);
S = [];
for ivar = 1:Nvar
   FN = inputname(ivar); % returns the caller's workspace variable name corresponding to the argument number ARGNO
   if isempty(FN)
      error(['arg #' num2str(ivar) ' has no name'])
   end
   S = setfield(S,FN,varargin{ivar}); % setfield(S,FIELD,V) sets the contents of the specified field to the
                                      % value V.  For example, setfield(S,'a',V) is equivalent to the syntax
                                      % S.field = V, and sets the value of field 'a' as V
end