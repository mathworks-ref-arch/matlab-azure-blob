function uriM = getUri(obj, varargin)
% GETURI Returns the URI for this table
% The URI is returned as a matlab.net.URI, this may be used when
% constructing a shared access signature for example.
%
%    % get the URI for a table
%    mytable.getUri
%    ans =
%    URI with properties:
%
%                Scheme: "https"
%              UserInfo: [0x0 string]
%                  Host: "myaccount.table.core.windows.net"
%                  Port: []
%      EncodedAuthority: "myaccount.table.core.windows.net"
%                  Path: [""    "mysampletable"]
%           EncodedPath: "/mbsampletable"
%                 Query: [0x0 matlab.net.QueryParameter]
%          EncodedQuery: ""
%              Fragment: [0x0 string]
%              Absolute: 1
%            EncodedURI: "https://myaccount.table.core.windows.net/mysampletable"
%

% Copyright 2018 The MathWorks, Inc.


uriJ = obj.Handle.getUri();

uriM = matlab.net.URI(char(uriJ.toString));

end %function
