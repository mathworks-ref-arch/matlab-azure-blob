function md5 = getContentMD5(obj)
% GETCONTENTMD5 Gets the MD5 of the blob content
% Before using getContentMD5() call downloadAttributes() and getProperties() for the
% blob. The result is returned as a character vector.
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
%  props.getContentMD5
%  ans =
%      '70ac56fbb040f7b14026308d0722152f'

% Copyright 2019 The MathWorks, Inc.

%logObj = Logger.getLogger();

md5 = char(obj.Handle.getContentMD5());

end %function
