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
    %

    % Copyright 2018 The MathWorks, Inc.

    enumeration
        ADD
        CREATE
        DELETE
        READ
        WRITE
    end

end %class
