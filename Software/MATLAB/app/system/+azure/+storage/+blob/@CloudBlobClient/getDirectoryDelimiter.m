function delimiter = getDirectoryDelimiter(obj)
% GETDIRECTORYDELIMITER Returns delimiter used for cloud blob directories
% Method returns the value for the default delimiter used for cloud blob
% directories. The default is '/'. The value of the delimiter used by a client
% can be set using setDirectoryDelimiter. Using the default / is strongly
% recommended.

% Copyright 2016 The MathWorks, Inc.

delimiter = obj.DirectoryDelimiter;

end
