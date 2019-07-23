function time = getNextVisibleTime(obj)
% GETNEXTVISIBILITYTIME Gets the time that the message will next be visible
% The time is returned as a datetime.

% Copyright 2019 The MathWorks, Inc.

timeJ = obj.Handle.getNextVisibleTime();
time = datetime(timeJ.getTime()/1000,'convertfrom','posixtime','TimeZone','UTC');

end
