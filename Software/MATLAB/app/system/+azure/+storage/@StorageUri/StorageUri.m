classdef StorageUri < azure.object
% STORAGEURI class used for storage URIs e.g. for CloudBlobDirectory
%
% A StorageUri object can be created in two ways, it can be constructed using
% a Java com.microsoft.azure.storage.StorageUri object:
%
%    myStorageUri = StorageUri(my_com_microsoft_azure_storage_StorageUri);
%
% or alternatively it can be constructed by passing in URIs for the primary and
% or secondary URIs:
%    myStorageUri = StorageUri(matlab.net.URI('myUriValue'));
%
%    myStorageUri = StorageUri(matlab.net.URI('myUriValue1'), matlab.net.URI('myUriValue1'));
%
% If passing URLs directly first convert them to matlab.net.URI type as shown.
%

% Copyright 2018 The MathWorks, Inc.


properties(SetAccess=immutable)
    PrimaryUri
    SecondaryUri
end

methods
    %% constructor
    function obj = StorageUri(varargin)
        % Create a logger object
        logObj = Logger.getLogger();

        if isa(varargin{1},'com.microsoft.azure.storage.StorageUri')
            if nargin >1
                write(logObj,'warning','Expecting a single input parameter of type com.microsoft.azure.storage.StorageUri');
            end
            uriJ = varargin{1};
            obj.PrimaryUri = matlab.net.URI(uriJ.getPrimaryUri.toString());
            obj.SecondaryUri = matlab.net.URI(uriJ.getSecondarUri.toString());
            obj.Handle = uriJ;
        else
            % validate input as a MATLAB URI
            p = inputParser;
            p.CaseSensitive = false;
            p.FunctionName = 'StorageUri';
            checkURIClass = @(x) isa(x, 'matlab.net.URI');
            addRequired(p,'PrimaryUri',checkURIClass);
            addOptional(p,'SecondaryUri','',checkURIClass);

            parse(p,varargin{:});
            obj.PrimaryUri = p.Results.PrimaryUri;
            obj.SecondaryUri = p.Results.SecondaryUri;

            % pass the string form of the URI to the underlying constructor
            % after converting to a Java URI
            if isempty(obj.SecondaryUri)
                uriJ1 = java.net.URI(obj.PrimaryUri.string);
                obj.Handle = com.microsoft.azure.storage.StorageUri(uriJ1);
            else
                uriJ1 = java.net.URI(obj.PrimaryUri.string);
                uriJ2 = java.net.URI(obj.SecondaryUri.string);
                obj.Handle = com.microsoft.azure.storage.StorageUri(uriJ1, uriJ2);
            end
        end
    end % function

end % methods

end % class