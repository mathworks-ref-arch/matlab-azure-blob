function lastModified = getLastModified(obj)
% GETLASTMODIFIED Gets the last modification time of the blob
% Before using getLastModified() call downloadAttributes() and getProperties()
% for the blob.
% The output time is of type datetime and will be returned with a UTC timezone.
%
% Example:
%  % Given an existing container with a number of blobs
%  azContainer = azure.storage.blob.CloudBlobContainer(azClient,'testcontainer');
%  % get a list of the blobs in the container
%  myList = azContainer.listBlobs();
%  % populate the properties and metadata
%  myList{1}.downloadAttributes();
%  % get the Properties
%  props = myList{1}.getProperties();
%  props.getLastModified
%  ans  =
%  datetime
%   01-Apr-2019 20:06:59

% Copyright 2019 The MathWorks, Inc.

lastModifiedJ = obj.Handle.getLastModified();

if isempty(lastModifiedJ)
    % Create a logger object
    logObj = Logger.getLogger();
    write(logObj,'error','lastModified not set');
else
    lastModified = datetime(lastModifiedJ.getTime()/1000,'convertfrom','posixtime','TimeZone','UTC');
end

end %function
