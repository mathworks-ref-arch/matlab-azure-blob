function appendText(obj, text)
% APPENDTEXT Appends a string to an append blob
% The the platform's default encoding is used. This API should be used strictly
% in a single writer scenario because the API internally uses the append-offset
% conditional header to avoid duplicate blocks which does not work in a
% multiple writer scenario.

% Copyright 2019 The MathWorks, Inc.

if ~ischar(text)
    logObj = Logger.getLogger();
    write(logObj,'error','Expected text to be a character vector');
end

obj.Handle.appendText(text);

end
