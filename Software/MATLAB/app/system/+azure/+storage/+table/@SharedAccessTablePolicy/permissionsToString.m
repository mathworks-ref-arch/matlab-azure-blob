function result = permissionsToString(obj)
% PERMISSIONSTOSTRING Converts policy permissions to a character vector
%
%   permSet(1) = azure.storage.table.SharedAccessTablePermissions.QUERY;
%   permSet(2) = azure.storage.table.SharedAccessTablePermissions.ADD;
%   permSet(3) = azure.storage.table.SharedAccessTablePermissions.DELETE;
%   myPolicy = azure.storage.table.SharedAccessTablePolicy();
%   myPolicy.setPermissions(permSet);
%   str = myPolicy.permissionsToString
%   str =
%       'rad'
%

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
%logObj = Logger.getLogger();

stringJ = obj.Handle.permissionsToString();

result = char(stringJ);

end
