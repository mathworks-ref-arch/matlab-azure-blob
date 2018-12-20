function helptext = extractHelp(filename)
% EXTRACTHELP returns the first comment block from a function or class
% The returned character vector includes newlines.
%
% Example:
%    myhelptext = extractHelp('/mydir/myfile.m')
%

% Copyright 2018 The MathWorks, Inc.

logObj = Logger.getLogger();

% default return empty string
helptext = '';

if ~ischar(filename)
    write(logObj,'error','Invalid argument');
    return
end


[fid, ferrmsg] = fopen(filename,'r');
if fid == -1
    write(logObj,'error',['Unable to open file: ',filename]);
    write(logObj,'error',['fopen error message: ',ferrmsg]);
    return;
end

line1 = strtrim(fgets(fid));
if startsWith(line1,'function','IgnoreCase',true)
    % Print a syntax line
    % helptext = ['  Syntax: ' line1(9:end) newline];
elseif startsWith(line1,'class','IgnoreCase',true)
    % Don't print syntax for Classes
else
    write(logObj,'error','Initial line is is not a class or function definition:');
    write(logObj,'error',line1);
    return;
end

comment = true;
while comment
    linen = fgets(fid);
    linentrim = strtrim(linen);

    if (~isempty(linentrim))
        if (linentrim(1) == '%')
            helptext = [helptext ' ' linentrim(2:end) newline ]; %#ok<AGROW>
        else
            comment = false;
        end
    else
        comment = false;
    end
end

fclose(fid);

end
