function receipt = getPopReceipt(obj)
% GETPOPRECEIPT Gets the message's pop receipt
% The receipt is returned as a character vector

% Copyright 2019 The MathWorks, Inc.

receipt = char(obj.Handle.getPopReceipt());

end
