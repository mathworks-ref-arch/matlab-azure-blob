function setInsertionTime(obj, time)
% SETINSERTIONTIME Sets the time that the message was inserted
% The time is provided as a datetime.

% Copyright 2019 The MathWorks, Inc.

if isdatetime(time)
    timeJ = java.util.Date(int64(posixtime(time)*1000));
    obj.Handle.setInsertionTime(timeJ);
else
    logObj = Logger.getLogger();
    write(logObj,'error','Expected time of type datetime');
end

end
