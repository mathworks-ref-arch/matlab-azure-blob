function appendFromFile(obj, filename)
% APPENDFROMFILE Appends a file to an append blob
% This method should be used strictly in a single writer scenario because the
% API internally uses the append-offset conditional header to avoid duplicate
% blocks which does not work in a multiple writer scenario.

% Copyright 2019 The MathWorks, Inc.

if exist(filename, 'file')
    % if the necessary file in place to read and upload
    obj.Handle.appendFromFile(filename);
else
    logObj = Logger.getLogger();
    write(logObj,'error',['File not found: ', filename]);
end

end
