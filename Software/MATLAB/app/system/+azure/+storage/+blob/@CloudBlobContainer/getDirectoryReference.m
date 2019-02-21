function directory = getDirectoryReference(obj, directoryName)
% GETDIRECTORYREFERENCE Returns a virtual blob directory within this container
% Returns a CloudBlobDirectory object to represent a directory of the given name
% within the current directory.
%
% Example:
%    myCloubBlobDirectory = azContainer.getDirectoryReference('mydirname')

% Copyright 2018 The MathWorks, Inc.

logObj = Logger.getLogger();

if ~ischar(directoryName)
    write(logObj,'error','Expected directory name of type character vector');
else
    CloudBlobDirectoryJ = obj.Handle.getDirectoryReference(directoryName);
    directory = azure.storage.blob.CloudBlobDirectory(CloudBlobDirectoryJ);
end

end %function
