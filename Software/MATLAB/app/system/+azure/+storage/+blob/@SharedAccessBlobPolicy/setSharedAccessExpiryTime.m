function setSharedAccessExpiryTime(obj, sharedAccessExpiryTime)
% SETSHAREDACCESSEXPIRYTIME Sets expiry time for shared access signatures
% The input time should be of type datetime
%
%    % create a policy and apply an expiry time to it, in this case 24
%    % hours from now
%    myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
%    t = datetime('now');
%    t = t + hours(24);
%    myPolicy.setSharedAccessExpiryTime(t)
%

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

% if NaT error
if isnat(sharedAccessExpiryTime)
    write(logObj,'error','Expected input of type datetime');
else
    etimeJ = java.util.Date(int64(posixtime(sharedAccessExpiryTime)*1000));
end

obj.Handle.setSharedAccessExpiryTime(etimeJ);

end
