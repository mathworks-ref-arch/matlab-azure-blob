function setNextVisibleTime(obj, time)
% SETNEXTVISIBLETIME Sets the time the message to become visible in the queue
% The time is provided as a datetime.

% Copyright 2019 The MathWorks, Inc.

if isdatetime(time)
    timeJ = java.util.Date(int64(posixtime(time)*1000));
    obj.Handle.setNextVisibleTime(timeJ);
else
    logObj = Logger.getLogger();
    write(logObj,'error','Expected time of type datetime');
end

end
