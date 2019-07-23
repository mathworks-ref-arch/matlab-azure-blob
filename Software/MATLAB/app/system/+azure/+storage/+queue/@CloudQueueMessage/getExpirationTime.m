function time = getExpirationTime(obj)
% GETEXPIRATIONTIME Gets the time that the message expires
% The time is returned as a datetime.

% Copyright 2019 The MathWorks, Inc.

timeJ = obj.Handle.getExpirationTime();
time = datetime(timeJ.getTime()/1000,'convertfrom','posixtime','TimeZone','UTC');

end
