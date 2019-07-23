classdef MessageUpdateFields  < azure.object
% MESSAGEUPDATEFIELDS Flags for the values to set when updating messages
%
% Valid values are:
%    CONTENT	 Set to update the message content.
%    VISIBILITY	 Set to update the message visibility timeout.

% Copyright 2019 The MathWorks, Inc.

enumeration
    CONTENT
    VISIBILITY
end

methods
    function typeJ = toJava(obj)
        switch obj
        case azure.storage.queue.MessageUpdateFields.CONTENT
            typeJ = com.microsoft.azure.storage.queue.MessageUpdateFields.CONTENT;
        case azure.storage.queue.MessageUpdateFields.VISIBILITY
            typeJ = com.microsoft.azure.storage.queue.MessageUpdateFields.VISIBILITY;
        otherwise
            logObj = Logger.getLogger();
            write(logObj,'error','azure.storage.queue.MessageUpdateFields');
        end
    end
end

end
