function content = getMessageContentAsByte(obj)
% GETMESSAGECONETENTASBYTE Gets message content as a byte array
% The content is returned as a uint8 array

% Copyright 2019 The MathWorks, Inc.

content = uint8(obj.Handle.getMessageContentAsByte());

end
