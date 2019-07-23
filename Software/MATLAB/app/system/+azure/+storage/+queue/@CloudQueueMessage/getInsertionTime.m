function time = getInsertionTime(obj)
% GETINSERTIONTIME Gets the time that the message was inserted
% The time is returned as a datetime.

% Copyright 2019 The MathWorks, Inc.

timeJ = obj.Handle.getInsertionTime();
time = datetime(timeJ.getTime()/1000,'convertfrom','posixtime','TimeZone','UTC');

end
