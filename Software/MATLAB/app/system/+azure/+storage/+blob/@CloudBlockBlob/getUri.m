function uriM = getUri(obj, varargin)
% GETURI Returns the URI for a CloudBlockBlob
% The URI is returned as a matlab.net.URI, this may be used when
% constructing a shared access signature for example.
%
%    % get the URI for a blob
%    myblob.getUri
%    ans =
%    URI with properties:
%
%                Scheme: "https"
%              UserInfo: [0x0 string]
%                  Host: "myaccount.blob.core.windows.net"
%                  Port: []
%      EncodedAuthority: "myaccount.blob.core.windows.net"
%                  Path: [""    "mycontainer"    "SampleData.mat"]
%           EncodedPath: "/mycontainer/SampleData.mat"
%                 Query: [0x0 matlab.net.QueryParameter]
%          EncodedQuery: ""
%              Fragment: [0x0 string]
%              Absolute: 1
%            EncodedURI: "https://myaccount.blob.core.windows.net/mycontainer/SampleData.mat"
%

% Copyright 2018 The MathWorks, Inc.


uriJ = obj.Handle.getUri();
uriM = matlab.net.URI(char(uriJ.toString));

end %function
