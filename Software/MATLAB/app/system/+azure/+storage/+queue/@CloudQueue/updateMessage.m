function updateMessage(obj, varargin)
% UPDATEMESSAGE Updates the specified message in the queue
% The updated updates the specified message in the queue with a new visibility
% timeout value in seconds or updates a set of fields using the specified
% request options and operation context.
%
% Example:
%    % updated the contents of a previously retrieved message
%    retrievedMessage.setMessageContent(newMsgStr);
%    % using defaults for QueueRequestOptions & OperationContext
%    requestOptions = azure.storage.queue.QueueRequestOptions();
%    operationContext = azure.storage.OperationContext();
%    % array of Enums for fields to be updated
%    updateFields(1) = azure.storage.queue.MessageUpdateFields.CONTENT;
%    updateFields(2) = azure.storage.queue.MessageUpdateFields.VISIBILITY;
%    % setting a visibility value less than the default of 30
%    visibilityTimeout = 10;
%    queue.updateMessage(retrievedMessage, visibilityTimeout, updateFields, requestOptions, operationContext);
%
%    
%    % or setting just the visibility timeout
%    queue.updateMessage(retrievedMessage, visibilityTimeout);
        

% Copyright 2019 The MathWorks, Inc.

p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'updateMessage';
isMessage = @(x) isa(x, 'azure.storage.queue.CloudQueueMessage');
addRequired(p,'message', isMessage);
visibilityChk = @(x) isnumeric(x) && isscalar(x);
addRequired(p,'visibility', visibilityChk);
isMessageUpdateFields = @(x) isa(x, 'azure.storage.queue.MessageUpdateFields');
addOptional(p, 'messageUpdateFields', [], isMessageUpdateFields);
isQueueRequestOptions = @(x) isa(x, 'azure.storage.queue.QueueRequestOptions');
addOptional(p, 'queueRequestOptions', [], isQueueRequestOptions);
isOpContext = @(x) isa(x, 'azure.storage.OperationContext');
addOptional(p, 'opContext', [], isOpContext);

parse(p,varargin{:});

% import for EnumSet
import java.util.*

message = p.Results.message;
visibility = p.Results.visibility;
messageUpdateFields = p.Results.messageUpdateFields;
queueRequestOptions = p.Results.queueRequestOptions;
opContext = p.Results.opContext;

if isempty(opContext) && isempty(messageUpdateFields) && isempty(queueRequestOptions)
    obj.Handle.updateMessage(message.Handle, visibility);
else
    switch char(messageUpdateFields(1))
        case 'CONTENT'
            enumSetJ = EnumSet.of(com.microsoft.azure.storage.queue.MessageUpdateFields.CONTENT);
        case 'VISIBILITY'
            enumSetJ = EnumSet.of(com.microsoft.azure.storage.queue.MessageUpdateFields.VISIBILITY);
        otherwise
            str =  char(messageUpdateFields(1));
            logObj = Logger.getLogger();
            write(logObj,'error',['Invalid messageUpdateFields enum value: ',str]);
    end %switch

    if numel(messageUpdateFields) > 1
        for n=2:numel(messageUpdateFields)
            switch char(messageUpdateFields(n))
                case 'CONTENT'
                    if ~enumSetJ.add(com.microsoft.azure.storage.queue.MessageUpdateFields.CONTENT)
                        write(logObj,'warning',['Error adding MessageUpdateFields enum value: ',char(messageUpdateFields(n))]);
                    end
                case 'VISIBILITY'
                    if ~enumSetJ.add(com.microsoft.azure.storage.queue.MessageUpdateFields.VISIBILITY)
                        write(logObj,'warning',['Error adding MessageUpdateFields enum value: ',char(messageUpdateFields(n))]);
                    end
                otherwise
                    str =  char(messageUpdateFields(n));
                    logObj = Logger.getLogger();
                    write(logObj,'error',['Invalid MessageUpdateFields enum value: ',str]);
            end %switch
        end
    end

    obj.Handle.updateMessage(message.Handle, visibility, enumSetJ, queueRequestOptions.Handle, opContext.Handle);
end

end
