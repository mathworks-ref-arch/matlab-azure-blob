function upload(obj)
% UPLOAD Method to upload CloudBlockBlob(s) to WASB
% This method will upload the current CloudBlockBlob reference(s) to WASB. When
% uploading the data to a container, first create a blob handle (merely a
% reference) and then upload. The upload 'path/location' in Azure is set in
% the Container not the CloudBlockBlob, which only sets the name.
%
%    blob = azContainer.getBlockBlobReference(which('SampleData.mat'));
%    blob.upload();
%
% This file is now available on the WASB service. The upload mechanism is
% vectorized. You can pass a full cell array of files to upload at once.
% For example, to upload a directory of files:
%
%    % Get a list of files
%    dirContents = dir('*.m');
%    filesToUpload = {dirContents.name};
%    blobs = azContainer.getBlockBlobReference(filesToUpload);
%    blobs.upload;
%    .................
%
% Dots are displayed as feedback for vectorized uploads if verbose logging is
% enabled.
%
% Unlike the Java Azure SDK the MATLAB Blob object stores the path of the local
% file for upload, this is set when the CloudBlockBlob is created. It is used at
% upload for the source file but the destination name the object is uploaded to
% is derived from the object Name value which is set when the MATLAB Blob object
% is constructed. These Names need not match and indeed generally do not as the
% local file object will contain path values that would not apply in WASB.
% One may commonly rely on the Container to provide the structure into which a
% Blob is uploaded using just it's file name as the Blob name, as set at Blob
% creation time.

% Copyright 2018 The MathWorks, Inc.

% Java Imports
import java.io.*;

% Create a logger object
logObj = Logger.getLogger();

% Simple progress
if strcmp(logObj.DisplayLevel, 'verbose') && numel(obj) > 1
    statusLog = true;
    fprintf(1,'\n');
else
    statusLog = false;
end

for oCount = 1:numel(obj)
    % Check that the upload path variable has been set
    if isempty(obj(oCount).LocalUploadPath)
        write(logObj,'warning','This Blob does not have a LocalUploadPath, thus it may be downloadable but cannot be uploaded');
        write(logObj,'error',['LocalUploadPath variable not set for: ', obj(oCount).Name]);
    end

    % A final check if the file really exists
    if exist(obj(oCount).LocalUploadPath, 'file')
        % We have the necessary file in place to read and upload
        % TODO replace with uploadToFile in newer SDK releases e.g. 8.0.0
        % or add error handling
        fileHandle = File(obj(oCount).LocalUploadPath);
        fileStream = FileInputStream(fileHandle);
        % Upload to WASB
        obj(oCount).Handle.upload(fileStream, fileHandle.length());
        fileStream.close;

        % Simple progress
        if statusLog
            fprintf(1,'.');
            if mod(oCount,80) == 0
                fprintf(1,'\n');
            end
        end
    else
        % the file does not exist so we can't upload it as an object
        write(logObj,'error',['Invalid file path: ', obj(oCount).LocalUploadPath]);
    end
end

% Simple progress
if statusLog
    fprintf(1,'\n');
end

end %function
