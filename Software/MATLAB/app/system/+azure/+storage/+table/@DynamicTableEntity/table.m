function outTable = table(obj, varargin)
% TABLE Method to cast a Dynamic Table Entity into a MATLAB table
% Converts the result into a table with the appropriate types. This method
% removes the handle from the DynamicTableEntity.

% Copyright 2018 The MathWorks, Inc.

warnState = warning('off','MATLAB:structOnObject');

% Attempt to marshal the data into a table
try

for oCount = 1:numel(obj)
    sArray(oCount) = rmfield(struct(obj(oCount)),'Handle'); %#ok<AGROW>
end

outTable = struct2table(sArray);

catch tErr
    warning(warnState.state,'MATLAB:structOnObject');
end


end %function
