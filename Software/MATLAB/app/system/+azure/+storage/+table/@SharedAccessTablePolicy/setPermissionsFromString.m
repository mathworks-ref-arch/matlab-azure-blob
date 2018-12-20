function setPermissionsFromString(obj, inp)
% SETPERMISSIONSFROMSTRING Set permissions using specified character vector
% A String that represents the shared access permissions. The string must
% contain one or more of the following values, and the order that they are
% specified must be in the order of "raud".
% r: Query access
% a: Add access
% u: Update access
% d: Delete access
%
%   % create a table policy object
%   myPolicy = azure.storage.table.SharedAccessTablePolicy();
%   % add read and add privilages to that policy
%   myPolicy.setPermissionsFromString('ra');
%

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

if ~ischar(inp)
  write(logObj,'error','Expected input of type character vector');
end

% value is the string that will be passed to the Handle method
value = '';

% for each character in the input string
for n=1:length(inp)
  % alwasy use lowercase value of that character
  V = lower(inp(n));
  % valid characters are raud
  if V=='r' || V=='a' || V=='u' || V=='d'
    % build up the 'value' string
    % NB repeated valid characters are not eliminated and order is not checked
    % if there is now character in value add one and then append thereafter
    if isempty(value)
        value(1) = V;
    else
        value(end+1) = V; %#ok<AGROW>
    end
  else
    % warn if not valid and drop it from the output string
    write(logObj,'warning',['Invalid input character: ',V]);
  end
end

% call the Handle method with a string
obj.Handle.setPermissionsFromString(string(value))

end
