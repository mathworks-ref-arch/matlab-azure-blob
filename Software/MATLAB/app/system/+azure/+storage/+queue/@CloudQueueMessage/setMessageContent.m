function setMessageContent(obj, content)
% SETMESSAGECONTENT Sets the content of a message
% The content should be of type character vector or a uint8 array

% Copyright 2019 The MathWorks, Inc.

if ischar(content)
    obj.Handle.setMessageContent(content);
elseif isa(content, 'uint8')
    obj.Handle.setMessageContent(content);
else
    logObj = Logger.getLogger();
    write(logObj,'error','Expected content of type character vector or uint8');
end

end
