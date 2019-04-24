classdef BlobType < azure.object
    % BLOBTYPE defines the various supported permissions
    %
    % Enumeration values are as follows:
    %
    % APPEND_BLOB    Specifies the blob is an append blob.
    % BLOCK_BLOB     Specifies the blob is a block blob.
    % PAGE_BLOB      Specifies the blob is a page blob.
    % UNSPECIFIED    Specifies the blob type is not specified.

    % Copyright 2019 The MathWorks, Inc.

    enumeration
        APPEND_BLOB
        BLOCK_BLOB
        PAGE_BLOB
        UNSPECIFIED
    end

end %class
