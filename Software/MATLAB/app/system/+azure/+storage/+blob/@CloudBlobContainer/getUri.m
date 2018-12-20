function uriM = getUri(obj, varargin)
% GETURI Returns the URI for this container
% The URI is returned as a matlab.net.URI object.


% Copyright 2018 The MathWorks, Inc.

uriJ = obj.Handle.getUri();

uriM = matlab.net.URI(char(uriJ.toString));

end %function
