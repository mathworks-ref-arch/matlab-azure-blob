function id = getMessageId(obj)
% GETMESSAGEID Gets the message ID
% The ID is returned as a character vector

% Copyright 2019 The MathWorks, Inc.

id = char(obj.Handle.getMessageId());

end
