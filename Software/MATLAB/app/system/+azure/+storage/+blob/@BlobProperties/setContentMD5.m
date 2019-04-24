function setContentMD5(obj, MD5)
% SETCONTENTMD5 Sets the content MD5 value for the blob

if ~ischar(MD5)
    logObj = Logger.getLogger();
    write(logObj,'error','Expected MD5 of type character vector');
end

obj.Handle.setContentMD5(MD5);

end
