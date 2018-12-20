function expiryTime = getSharedAccessExpiryTime(obj)
% GETSHAREDACESSEXPIRYTIME Gets expiry time for shared access signatures
% The output time is of type datetime, expiryTime will be returned with a
% UTC time zone.
%
%    % set the time to the current time and read it back
%    t1 = myPolicy.getSharedAccessStartTime();
%    t2 = datetime('now', 'TimeZone', 'UTC')
%    if (t1 > t2)
%        disp('Access period has expired');
%    end
%

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
%logObj = Logger.getLogger();

expiryTimeJ = obj.Handle.getExpiryAccessStartTime();
expiryTime = datetime(expiryTimeJ.getTime()/1000,'convertfrom','posixtime','TimeZone','UTC');

end
