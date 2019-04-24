function setSharedAccessStartTime(obj, sharedAccessStartTime)
% SETSHAREDACCESSSTARTTIME Sets start time for shared access signatures
% The input time should be of type datetime and should be in the UTC time zone.
%
%    % create a policy and set the time to the current time
%    myPolicy = azure.storage.table.SharedAccessTablePolicy();
%    t = datetime('now','TimeZone','UTC');
%    myPolicy.setSharedAccessStartTime(t)
%
% Microsoft recommend that if setting the start time to the current time
% that this time be set 15 minutes early to allow clock variations
%
%    t = datetime('now','TimeZone','UTC');
%    t = t - minutes(15);
%    myPolicy.setSharedAccessStartTime(t)

% Copyright 2018 The MathWorks, Inc.

% Create a logger object

% if NaT pass nulls to Java
if isnat(sharedAccessStartTime)
    logObj = Logger.getLogger();
    write(logObj,'error','Expected input of type datetime');
else
    etimeJ = java.util.Date(int64(posixtime(sharedAccessStartTime)*1000));
end

obj.Handle.setSharedAccessStartTime(etimeJ);

end
