function content = getMessageContentAsString(obj)
% GETMESSAGECONETENTASSTRING Gets message content as a string
% The content is returned as a character vector

% Copyright 2019 The MathWorks, Inc.

content = char(obj.Handle.getMessageContentAsString());

end
