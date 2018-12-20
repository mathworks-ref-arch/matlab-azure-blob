function result = permissionsToString(obj)
% PERMISSIONSTOSTRING Converts policy permissions to a character vector
%
%   permSet(1) = azure.storage.blob.SharedAccessBlobPermissions.ADD;
%   permSet(2) = azure.storage.blob.SharedAccessBlobPermissions.READ;
%   permSet(3) = azure.storage.blob.SharedAccessBlobPermissions.CREATE;
%   myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
%   myPolicy.setPermissions(permSet);
%   str = myPolicy.permissionsToString
%   str =
%       'rac'
%

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
%logObj = Logger.getLogger();

stringJ = obj.Handle.permissionsToString();

result = char(stringJ);

end
