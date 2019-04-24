function type = getBlobType(obj)
% GETBLOBTYPE Gets the type of the blob content
% Before using getBlobType() call downloadAttributes() and getProperties() for the
% blob. The result is returned as an azure.storage.blob.BlobType object.
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
%  type = props.getBlobType;

% Copyright 2019 The MathWorks, Inc.

%logObj = Logger.getLogger();

typeJ = obj.Handle.getBlobType();
typeStr = char(typeJ.toString());

switch typeStr
case 'APPEND_BLOB'
    type = azure.storage.blob.BlobType.APPEND_BLOB;
case 'BLOCK_BLOB'
    type = azure.storage.blob.BlobType.BLOCK_BLOB;
case 'PAGE_BLOB'
    type = azure.storage.blob.BlobType.PAGE_BLOB;
case 'UNSPECIFIED'
    type = azure.storage.blob.BlobType.UNSPECIFIED;
otherwise
    logObj = Logger.getLogger();
    write(logObj,'error',['Invalid BlobType enum value: ', typeStr]);
end

end %function
