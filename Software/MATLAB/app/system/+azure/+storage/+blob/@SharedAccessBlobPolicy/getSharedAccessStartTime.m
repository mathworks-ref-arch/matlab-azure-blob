function startTime = getSharedAccessStartTime(obj)
% GETSHAREDACCESSSTARTTIME Gets start time for shared access signatures
% The output time is of type datetime, startTime will be returned with a
% UTC time zone.
%
%    % get start time and compare with current time (UTC)
%    t1 = myPolicy.getSharedAccessStartTime();
%    t2 = datetime('now', 'TimeZone', 'UTC');
%    if (t2 > t1)
%       disp('Access period has started');
%    end
%

% Copyright 2018 The MathWorks, Inc.

startTimeJ = obj.Handle.getSharedAccessStartTime();
if isempty(startTimeJ)
    % Create a logger object
    logObj = Logger.getLogger();
    write(logObj,'error','SharedAccessStartTime not set');
else
    startTime = datetime(startTimeJ.getTime()/1000,'convertfrom','posixtime','TimeZone','UTC');
end
end
