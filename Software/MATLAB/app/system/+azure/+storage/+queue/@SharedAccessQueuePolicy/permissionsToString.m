function result = permissionsToString(obj)
% PERMISSIONSTOSTRING Converts policy permissions to a character vector
%
%   permSet(1) = azure.storage.queue.SharedAccessQueuePermissions.ADD;
%   permSet(2) = azure.storage.queue.SharedAccessQueuePermissions.READ;
%   permSet(3) = azure.storage.queue.SharedAccessQueuePermissions.UPDATE;
%   myPolicy = azure.storage.queue.SharedAccessQueuePolicy();
%   myPolicy.setPermissions(permSet);
%   str = myPolicy.permissionsToString
%   str =
%       'rac'
%

% Copyright 2019 The MathWorks, Inc.

% Create a logger object
%logObj = Logger.getLogger();

stringJ = obj.Handle.permissionsToString();

result = char(stringJ);

end
