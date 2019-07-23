function  setDefaultProxy(obj, varargin)
% SETDEFAULTPROXY Sets the default proxy server used by the client
% By default setDefaultProxy use the MATLAB settings or if not set and on
% Windows the systems preferences will be used.
% Specific values can also be used.
%
% Examples:
%    Set the default client proxy to that set in the MATLAB preferences
%    panel, if preferences are not set then use system preferences (Windows only):
%        oc = azure.storage.OperationContext();
%        oc.setDefaultProxy();
%
%    Set the default proxy to a specific value:
%        oc.setDefaultProxy('myproxy.mycompany.com', 8080);
%
%    Set the default to a direct connection i.e. no proxy
%        oc.setDefaultProxy('NO_PROXY');
%

% Copyright 2017 The MathWorks, Inc.

import com.microsoft.azure.storage.OperationContext

% Create a logger object
logObj = Logger.getLogger();

if isempty(varargin)
    % Read the host values from the MATLAB preferences using
    % getProxySettings in matlab.internal.webservices.HTTPConnector
    % approach
    % Get the proxy information using the MATLAB proxy API.
    % Ensure the Java proxy settings are set.
    com.mathworks.mlwidgets.html.HTMLPrefs.setProxySettings;

    % Obtain the proxy information for a given URL. Proxy settings can be
    % specific to URLs but this is unlikely
    url = java.net.URL('http://www.mathworks.com');
    % This function goes to MATLAB's preference panel or (if not set and on
    % Windows) the system preferences.
    javaProxy = com.mathworks.webproxy.WebproxyFactory.findProxyForURL(url);

    if ~isempty(javaProxy)
        address = javaProxy.address;
        if isa(address,'java.net.InetSocketAddress') && ...
                javaProxy.type == javaMethod('valueOf','java.net.Proxy$Type','HTTP')
            host = char(address.getHostName());
            port = address.getPort();
            write(logObj,'verbose',['Setting default proxy to: ',host,':',port]);
        else
            write(logObj,'error','Invalid proxy');
        end
    else
        write(logObj,'verbose','Setting default proxy to direct connection');
        javaProxy = java.net.Proxy.NO_PROXY;
    end
elseif (length(varargin) == 1) && isa(varargin{1}, 'char')
    if strcmpi(varargin{1},'NO_PROXY')
        write(logObj,'verbose','Setting default proxy to direct connection');
        javaProxy = java.net.Proxy.NO_PROXY;
    else
        write(logObj,'warning',['Invalid argument: ',varargin{1}]);
        write(logObj,'warning','Setting default proxy to direct connection');
        javaProxy = java.net.Proxy.NO_PROXY;
    end
elseif (length(varargin) == 2) && isa(varargin{1}, 'char') && isnumeric(varargin{2}) && isscalar(varargin{2})
    % if there is a host char and port number use them
    host = varargin{1};
    port = varargin{2};

    write(logObj,'verbose',['Setting default proxy to: ',host,':',port]);
    socket = java.net.InetSocketAddress(host, port);
    proxy_http_type = javaMethod('valueOf','java.net.Proxy$Type','HTTP');
    javaProxy = java.net.Proxy(proxy_http_type, socket);
else
    % in case of error set to no proxy
    write(logObj,'warning','Error: Invalid arguments');
    write(logObj,'warning','Setting default proxy to direct connection');
    javaProxy =  java.net.Proxy.NO_PROXY;
end

% Set the proxy based on the value specified
obj.Handle.setDefaultProxy(javaProxy);

end % function
