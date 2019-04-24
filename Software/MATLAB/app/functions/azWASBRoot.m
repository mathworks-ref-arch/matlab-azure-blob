function [str] = azWASBRoot(varargin)
% AZWASBROOT Helper function to locate the Azure WASB interface
%
% Locate the installation of the Azure interface package to allow easier construction
% of absolute paths to the required dependencies.

% Copyright 2016 The MathWorks, Inc.

str = fileparts(fileparts(fileparts(mfilename('fullpath'))));

end %function
