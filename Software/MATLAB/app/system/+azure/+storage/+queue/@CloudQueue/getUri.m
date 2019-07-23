function uri = getUri(obj)
% GETSTORAGEURI Gets the absolute URI for this queue

% Copyright 2019 The MathWorks, Inc.

uri = matlab.net.URI(char(obj.Handle.getUri.toString));

end
