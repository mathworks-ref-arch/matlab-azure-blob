function results = deleteIfExists(obj, varargin)
% DELETEIFEXISTS Delete a CloudAppendBlob or and array of CloudAppendBlobs
% Use this method to delete one or more blobs from a container.
%
%   % delete a single blob from a cell array
%   blobs = azContainer.listBlobs();
%   blobs{1}.deleteIfExists();
%
% If an array (NOT a cell array) of blobs is provided then the method will act
% on each instance. An array of logical values results is returned corresponding
% to the input blockblobs. True is returned if an appendblob is deleted otherwise
% false is returned. If vectorized input is used and verbose logging is enabled
% then a progress bar of '.' is displayed for each appendblob processed.
%
%  myBlobArray.deleteIfExists
%  .....
%
%  ans =
%
%    3x1 logical array
%
%     1
%     1
%     1

% Copyright 2016 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

% Simple progress
if strcmp(logObj.DisplayLevel, 'verbose') && numel(obj) > 1
    statusLog = true;
    fprintf(1,'\n');
else
    statusLog = false;
end

% declare false return values by default
if numel(obj) <= 1
    results(1,1) = false;
else
    results = false(numel(obj),1);
end


for bCount = 1:numel(obj)
    results(bCount, 1) = obj(bCount).Handle.deleteIfExists();

    % Simple progress
    if statusLog
        fprintf(1,'.');
        if mod(bCount,80) == 0
            fprintf(1,'\n');
        end
    end
end

% Simple progress
if statusLog
    fprintf(1,'\n');
end

end %function
