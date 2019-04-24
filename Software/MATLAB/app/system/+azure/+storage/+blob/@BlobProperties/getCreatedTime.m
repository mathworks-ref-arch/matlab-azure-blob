function createdTime = getCreatedTime(obj)
% GETCREATEDTIME Gets the creation time of the blob
% Before using getCreatedTime() call downloadAttributes() and getProperties()
% for the blob.
% The output time is of type datetime and will be returned with a UTC time zone.
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
%  props.getCreatedTime
%  ans =
%  datetime
%   01-Apr-2019 20:16:57

% Copyright 2019 The MathWorks, Inc.

createdTimeJ = obj.Handle.getCreatedTime();

if isempty(createdTimeJ)
    % Create a logger object
    logObj = Logger.getLogger();
    write(logObj,'error','createdTime not set');
else
    createdTime = datetime(createdTimeJ.getTime()/1000,'convertfrom','posixtime','TimeZone','UTC');
end

end %function
