function prefix = getPrefix(obj)
% GETPREFIX returns the prefix of the a CloudBlobDirectory

% Copyright 2016 The MathWorks, Inc.

% Create a logger object
% logObj = Logger.getLogger();

prefix = char(obj.Handle.getPrefix());

end
