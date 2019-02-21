classdef CloudBlockBlob < azure.object
    % CLOUDBLOCKBLOB Class to represent an Azure CloudBlockBlob object
    % A BlockBlob can be created in several ways. In the first example a
    % container handle is provided along with the name of the BloblBlob
    % once uploaded. A CloudBlockBlob object does not
    % guarantee a file exists, for example a BlockBlob may be downloadable
    % rather than uploadable i.e. it exists in Azure but not locally.
    % In the second A local file path is provided that the file blob maps to.
    %
    % Examples:
    % Create blob based on a blob name of SampleData.mat
    %   blob = azure.storage.blob.CloudBlockBlob(azContainer, 'SampleData.mat');
    %
    % A blob based on a local file:
    %   blob = azure.storage.blob.CloudBlockBlob(azContainer, ...
    %             'SampleData.mat', './my/local/path/SampleData.mat');
    %
    % A blob can be uploaded with a name other than its filename as follows:
    %   blob = azure.storage.blob.CloudBlockBlob(azContainer, ...
    %             'mydir/mynewblobname.mat', which('SampleData.mat'));
    % Note virtual directory hierarchy in the uploaded blob can be introduced
    % by prepending it to the name. This method can be used to create
    % a virtual directory 'mydir' Azure will represent this as a
    % CloudBlobDirectory. Empty virtual directories are not supported.
    %
    % A BlockBlob can also be created based on a Shared Access Signature for a
    % BlockBlob
    %
    %   blob = azure.storage.blob.CloudBlockBlob(mySAS_StorageUri);

    % Copyright 2018 The MathWorks, Inc.

    properties
        Name;
    end

    properties(Hidden)
        LocalUploadPath;
    end

    methods
        %% Constructor
        function obj = CloudBlockBlob(varargin)
            % Create a logger object
            logObj = Logger.getLogger();

            switch(nargin)
                case 1
                    % assume a SAS token has been provided
                    % e.g.  blob = azure.storage.blob.CloudBlockBlob(mySAS_StorageUri);
                    % Note, the LocalUploadPath is not set in this case
                    sURI = varargin{1};
                    if isa(sURI,'azure.storage.StorageUri')
                        obj.Handle = com.microsoft.azure.storage.blob.CloudBlockBlob(sURI.Handle);
                        obj.Name = char(obj.Handle.getName());
                    else
                        write(logObj,'error','Invalid SAS URI argument, expected an azure.storage.StorageURI');
                    end


                case 2
                    % construct a blob that does not have a local path e.g. output from listblobs
                    % e.g.  blob = azure.storage.blob.CloudBlockBlob(azContainer, blobname);
                    % Note, the LocalUploadPath is not set in this case
                    if ~isa(varargin{1}, 'azure.storage.blob.CloudBlobContainer')
                        write(logObj,'error','Invalid Container object argument, expected an azure.storage.blob.CloudBlobContainer');
                    end
                    container = varargin{1};

                    if ~ischar(varargin{2})
                        write(logObj,'error','Invalid Blob name argument, expected a character vector');
                    end
                    obj.Name = varargin{2}; % already a char

                    % Get the reference to the blob and store it as a handle
                    % there are no separators in the name as just the name and
                    % extension are stored
                    obj.Handle = container.Handle.getBlockBlobReference(obj.Name);


                case 3
                    % e.g.  blob = azure.storage.blob.CloudBlockBlob(azContainer, 'mydir/myAzureblobname.mat', '/my/local/path/SampleData.mat');
                    % as in the case of nargin == 2 but an alternate name is provided
                    if ~isa(varargin{1}, 'azure.storage.blob.CloudBlobContainer')
                        write(logObj,'error','Invalid Container argument, expected an azure.storage.blob.CloudBlobContainer');
                    end
                    container = varargin{1};

                    if ~ischar(varargin{2})
                        write(logObj,'error','Invalid alternate name argument, expected a character vector');
                    end
                    % Note name may have invalid separators this is resolved at upload
                    obj.Name = varargin{2};

                    if ~ischar(varargin{3})
                        write(logObj,'error','Invalid file name argument, expected a character vector');
                    end
                    % Note the actual path for later upload, The LocalUploadPath
                    % is hidden this is used by the blob's
                    % upload method to locate and work with the actual file.
                    obj.LocalUploadPath  = varargin{3};

                    obj.Handle = container.Handle.getBlockBlobReference(obj.Name);

                otherwise
                    write(logObj,'error','Invalid number of arguments');

            end %switch
        end %function
    end %methods
end %class
