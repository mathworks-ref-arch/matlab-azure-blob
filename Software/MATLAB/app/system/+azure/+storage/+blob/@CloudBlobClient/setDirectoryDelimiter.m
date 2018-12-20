function setDirectoryDelimiter(obj, delimiter)
% SETDIRECTORYDELIMITER sets the directory delimiter for use with this client
% By default the client is created with '/' as the delimiter
% In the unlikely event that another delimiter is preferred then it can be set
% as follows before the client is used, this should be done with caution and is
% strongly discouraged, a warning message is displayed:
%
% Example:
%     % Create a client Object
%     client = azure.storage.blob.CloudBlobClient(az);
%     % Set delimiter to a \
%     client.setDirectoryDelimiter('\');

% Copyright 2016 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

if ischar(delimiter)
    obj.DirectoryDelimiter = delimiter;
    if ~strcmp(delimiter,'/')
        write(logObj,'warning','Setting delimiter to a character other than /');
    end
else
    write(logObj,'error','Expected delimiter of type character vector');
end

end
