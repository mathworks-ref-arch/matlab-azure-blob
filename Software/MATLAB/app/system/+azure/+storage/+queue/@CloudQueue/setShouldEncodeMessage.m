function setShouldEncodeMessage(obj, shouldEncodeMessage)
% SETSHOULDENCODEMESSAGE Sets the flag to base-64 encoded messages
% shouldEncodeMessage should be of type logical.

% Copyright 2019 The MathWorks, Inc.

if islogical(shouldEncodeMessage)
    obj.Handle.setShouldEncodeMessage(shouldEncodeMessage);
else
    logObj = Logger.getLogger();
    write(logObj,'error','Expected shouldEncodeMessage of type logical');
end

end
