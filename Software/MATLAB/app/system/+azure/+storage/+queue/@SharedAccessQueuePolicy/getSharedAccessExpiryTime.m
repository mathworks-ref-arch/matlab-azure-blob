function expiryTime = getSharedAccessExpiryTime(obj)
% GETSHAREDACESSEXPIRYTIME Gets expiry time for shared access signatures
% The output time is of type datetime, expiryTime will be returned with a
% UTC time zone.
%
%    % check the expiry time is greater than the current time
%    t1 = myPolicy.getSharedAccessExpiryTime();
%    t2 = datetime('now', 'TimeZone', 'UTC')
%    if (t2 > t1)
%        disp('Access period has expired');
%    end
%

% Copyright 2019 The MathWorks, Inc.

expiryTimeJ = obj.Handle.getSharedAccessExpiryTime();

if isempty(expiryTimeJ)
    logObj = Logger.getLogger();
    write(logObj,'error','SharedAccessExpiryTime not set');
else
    expiryTime = datetime(expiryTimeJ.getTime()/1000,'convertfrom','posixtime','TimeZone','UTC');
end

end
