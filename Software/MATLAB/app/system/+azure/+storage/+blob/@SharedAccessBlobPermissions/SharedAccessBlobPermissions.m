classdef SharedAccessBlobPermissions < azure.object
    % SHAREDACCESSBLOBPERMISSIONS defines the various supported permissions
    %
    % Enumeration values are as follows:
    %
    % ADD    :  Specifies Add access granted
    % CREATE :  Specifies Create access granted
    % DELETE :  Specifies Delete access granted
    % READ   :  Specifies Read access granted
    % WRITE  :  Specifies Write access granted
    % LIST   :  Specifies List access granted
    %           List is undocumented in the Java SDK version 8.0.0 and lower
    %           However it appears fully implemented in line with other languages
    %           and is required for use with CloudBlobContainers
    %

    % Copyright 2018 The MathWorks, Inc.

    enumeration
        ADD
        CREATE
        DELETE
        READ
        WRITE
        LIST
    end

end %class
