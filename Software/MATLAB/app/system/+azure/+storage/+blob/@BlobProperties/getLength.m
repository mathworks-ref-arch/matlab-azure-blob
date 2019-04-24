function length = getLength(obj)
% GETLENGTH Gets the size, in bytes, of the blob
% Before using getLength() call downloadAttributes() and getProperties()
% for the blob.
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
%  props.getLength
%  ans =
%      7566357

% Copyright 2018 The MathWorks, Inc.

%logObj = Logger.getLogger();

% Handle.getLength() returns a long which represents the length of the blob
length = obj.Handle.getLength();

end %function
