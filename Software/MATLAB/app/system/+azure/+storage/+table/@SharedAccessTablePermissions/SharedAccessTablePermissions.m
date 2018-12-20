classdef SharedAccessTablePermissions < azure.object
    % SHAREDACCESSTablePERMISSIONS defines the various supported permissions
    %
    % Enumeration values are as follows:
    %
    % ADD    :  Permission to add entities granted
    % DELETE :  Permission to delete entities granted
    % NONE   :  No shared access granted
    % QUERY  :  Permission to query entities granted
    % UPDATE :  Permission to modify entities granted
    %

    % Copyright 2018 The MathWorks, Inc.

    enumeration
        ADD
        DELETE
        NONE
        QUERY
        UPDATE
    end

end %class
