function save(obj, blobname, varargin)
% SAVE Save variables to an Azure WASB CloudBlockBlob
% Save will overwrite existing blobs and create parent virtual directories if
% required.
%
% Save can be used very much like the functional form of the built-in save
% command with two exceptions:
%   1) The '-append' option is not supported.
%   2) An entire workspace cannot be saved i.e. Container.save('myfile.mat')
%      because the Azure WASB objects are not serializable. The
%      workspace variables should be listed explicitly to overcome this.
%
% Example:
%       % save the variables x and y to a blob holding a .mat file
%       y = rand(10);
%       x = rand(10);
%       mycontainer.save('myblobname.mat', 'x', 'y');

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

% assume same syntax as build-in save as will pass varargin through
if ~ischar(blobname)
    write(logObj,'error','Invalid filename type expecting character vector');
    return;
end

% scan varargin for -append
% can't handle this as the file being appended to is not local it would
% have to be downloaded first, see also CloudBlockBlob.download()
for n = 1:numel(varargin)
    if ischar(varargin{n})
        if strcmpi(varargin{n}, '-append')
            write(logObj,'error','-append is not support when saving to Azure WASB');
            return;
        end
    end
end

if nargin == 2
    str1 = 'Cannot save the complete workspace as the Azure Data Lake objects are not serializable, ';
    str2 = 'Instead specify the variables to be saved: ';
    str3 = 'myContainer.save(''myblobname.mat'', ''x'', ''y'');';
    write(logObj,'error', [str1, str2, str3]);
    return
else
    % create a temp file and use built in save to save there
    % use the extension used for the blobname
    [~, ~ , blobExt] = fileparts(blobname);
    tmpName = [tempname, blobExt];

    % build an expression to pass to a built-in save in the calling workspace
    % function ins the calling workspace will not be saved
    expr = 'save(';
    expr = [expr '''' tmpName ''''];
    for n = 1:numel(varargin)
        expr = [expr ',' '''' varargin{n} '''']; %#ok<AGROW>
    end
    expr = [expr ')'];
    evalin('caller', expr);
end

% create a blob reference from this container using the local tmp name and the
% destination blob name and then upload
blob = obj.getBlockBlobReference(tmpName, blobname);
blob.upload();

% remove the tmp file
delete(tmpName);

end %function
