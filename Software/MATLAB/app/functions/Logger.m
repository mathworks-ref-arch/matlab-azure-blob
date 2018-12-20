classdef Logger < handle
    % Logger - Object definition for Logger
    % ---------------------------------------------------------------------
    % Abstract: A logger object to encapsulate logging and debugging
    %           messages for a MATLAB application.
    %
    % Syntax:
    %           logObj = Logger.getLogger();
    %
    % Logger Properties:
    %
    %     LogFileLevel - The level of log messages that will be saved to the
    %     log file
    %
    %     DisplayLevel - The level of log messages that will be displayed
    %     in the command window
    %
    %     LogFile - The file name or path to the log file. If empty,
    %     nothing will be logged to file.
    %
    %     Messages - Structure array containing log messages
    %
    % Logger Methods:
    %
    %     clearMessages(obj) - Clears the log messages currently stored in
    %     the Logger object
    %
    %     clearLogFile(obj) - Clears the log messages currently stored in
    %     the log file
    %
    %     write(obj,Level,MessageText) - Writes a message to the log
    %
    % Examples:
    %     logObj = Logger.getLogger();
    %     write(logObj,'warning','My warning message')
    %

    % Copyright 2013 The MathWorks, Inc.
    %
    % Auth/Revision:
    %   MathWorks Consulting
    %   $Author$
    %   $Revision$  $Date$
    % ---------------------------------------------------------------------

    %% Public properties
    % These properties can be read or written to from outside the methods
    % of this object.
    properties
        LogFileLevel = 'warning' %Log message level for messages to be saved
        DisplayLevel = 'debug' %Log message level for messages to be displayed in the command window
        LogFile = '' %Name or path to the log file
        MsgPrefix = 'LOGGER:prefix' %prefix used for warning and error messages
    end

    %% Read-only properties
    % These properties are read-only, meaning they may be set only within
    % methods of this object.
    properties (SetAccess=protected, GetAccess=public)
        Messages = struct('Timestamp',{},'LevelIndex',{},'LevelName',{},'Message',{},'ErrorDetails',{})
    end

    %% Hidden properties
    % These properties are hidden values that may be needed by the class
    % methods, but do not need to be exposed as gettable or settable
    % properties.
    properties (SetAccess=protected, GetAccess=protected)
        FileId
    end

    %% Constants
    % These properties are constant values for this object. The value can
    % not be changed.
    properties (Constant=true)
        % These are the different debugging levels, sorted from lowest to
        % highest severity
        ValidLevels = {
            'verbose'
            'debug'
            'warning'
            'error'
            }
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Constructor
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % A constructor method is a special function that creates an instance
    % of the class. Typically, constructor methods accept input arguments
    % to assign the data stored in properties and always return an
    % initialized object.
    %
    % This constructor is set to private to create a singleton class. This
    % is because we want to only allow one instance of the Logger, which
    % can be retrieved from anywhere in the MATLAB session.
    methods (Access = private)
        function obj = Logger()
        end
    end %methods


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Destructor
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        function delete(obj)
            % If a log file was open, close it
            if ~isempty(obj.FileId)
                Status = fclose(obj.FileId);
                % Warn if the file could not be closed
                if Status~=0
                    warning('Logger:CloseFile',...
                        'Unable to close log file ''%s''.\n',...
                        obj.LogFile);
                end
            end
        end
    end %methods


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Static Methods
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Static methods are associated with a class, but not with specific
    % instances of that class. These methods do not perform operations on
    % individual objects of a class and, therefore, do not require an
    % instance of the class as an input argument, like ordinary methods.
    methods (Static = true)
        function obj = getLogger()
            % This method returns the singleton logger object. Only one
            % logger is allowed in a MATLAB session, and this method will
            % retrieve it.

            persistent SingletonLogger

            % Does the Logger need to be instantiated?
            if isempty(SingletonLogger) || ~isvalid(SingletonLogger)
                SingletonLogger = Logger;
            end

            % Output the logger
            obj = SingletonLogger;

        end
    end %static methods


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Public Methods
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Methods are functions that implement the operations performed on
    % objects of a class. They may be stored within the classdef file or as
    % separate files in a @classname folder.
    methods

        function clearMessages(obj)
            % clearMessages - Method to clear messages in the Logger
            % -------------------------------------------------------------------------
            % Abstract: Clears the log messages currently stored in the
            % Logger object
            %
            % Syntax:
            %       logObj.clearMessages(Level)
            %       clearMessages(logObj)
            %
            % Inputs:
            %       logObj - Logger object
            %
            % Outputs:
            %       none
            %

            obj.Messages(:) = [];

        end

        function clearLogFile(obj)
            % clearLogFile - Method to clear messages in the log file
            % -------------------------------------------------------------------------
            % Abstract: Clears the log messages currently stored in the log
            % file
            %
            % Syntax:
            %       logObj.clearLogFile(Level)
            %       clearLogFile(logObj)
            %
            % Inputs:
            %       logObj - Logger object
            %
            % Outputs:
            %       none
            %

            % Close the log file
            obj.closeLogFile();

            % Open the log file again and overwrite
            openLogFile(obj,obj.LogFile,'w');

        end


        function write(obj,Level,MessageText,varargin)
            % write - Method to write messages to the Logger
            % -------------------------------------------------------------------------
            % Abstract: Adds a new message to the Logger, with the
            % specified message level and text
            %
            % Syntax:
            %       logObj.write(Level,MessageText)
            %       write(logObj,Level,MessageText)
            %
            % Inputs:
            %       logObj - Logger object
            %       Level - Message level string ('debug','warning',etc)
            %       MessageText - Message text string
            %
            % Outputs:
            %       none
            %
            % Examples:
            %       logObj = Logger.getLogger;
            %       write(logObj,'warning','My warning message')
            %

            % Validate the level is one of the valid levels
            Level = validatestring(Level,obj.ValidLevels);

            % Get the level of this message
            idxLevel = find(strcmp(Level,obj.ValidLevels),1);

            if length(varargin) == 1
                if isstruct(varargin{1})
                    NMErrorStruct = varargin{1};
                else
                    error('Invalid argument: Expected errorStruct');
                end
            else
                % if a errorStruct is not passed in create one
                NMErrorStruct = struct('message','','identifier','');
            end

            % Save the message to the log
            NewMessage = struct(...
                'Timestamp',now,...
                'LevelIndex',idxLevel,...
                'LevelName',Level,...
                'Message',MessageText,...
                'ErrorDetails',NMErrorStruct);
            obj.Messages(end+1) = NewMessage;

            % Process the messages
            obj.processMessage(NewMessage);

        end

    end %public methods


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Protected Methods
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Protected methods operate on the data in the object, but they can
    % only be called from other methods of the class or subclass.
    methods (Access = protected)

        function processMessage(obj,NewMessage)

            % Should the message be displayed in the command window?
            DispLevelIdx = find(strcmp(obj.DisplayLevel,obj.ValidLevels),1);
            if NewMessage.LevelIndex>=DispLevelIdx
                if strcmpi(NewMessage.LevelName, 'warning')
                    tmpWarningStruct = warning;
                    warning('off', 'backtrace');
                    warning([obj.MsgPrefix, ' ', NewMessage.Message]);
                    warning(tmpWarningStruct);
                elseif strcmpi(NewMessage.LevelName, 'error')
                    % don't use the errorStruct message field as there is
                    % already a message field
                    NewMessage.ErrorDetails.message = NewMessage.Message;
                    % if the identifier field does NOT exist populate it with the logger prefix
                    if ~isfield(NewMessage.ErrorDetails,'identifier')
                        NewMessage.ErrorDetails.identifier = obj.MsgPrefix;
                    end
                    % if the identifier is empty set it to the prefix
                    if isempty(NewMessage.ErrorDetails.identifier)
                        NewMessage.ErrorDetails.identifier = obj.MsgPrefix;
                    end
                    % throw the error with the struture
                    error(NewMessage.ErrorDetails);
                else
                    % not a warning or an error so just display it
                    disp(NewMessage.Message);
                end
            end

            % Should the message be written to the log file?
            FileLevelIdx = find(strcmp(obj.LogFileLevel,obj.ValidLevels),1);
            if NewMessage.LevelIndex>=FileLevelIdx && ~isempty(obj.FileId)
                % Create a comma delimited message, followed by a
                % line terminator
                fprintf(obj.FileId,'%s, %s, "%s"\r\n',...
                    datestr(NewMessage.Timestamp),... %current date & time
                    upper(NewMessage.LevelName),... %uppercase level string
                    NewMessage.Message); %message as quoted string
                if strcmpi(NewMessage.LevelName,'error')
                    fprintf('ID: %s, file: %s, name %s, line: %d\r\n',...
                             NewMessage.ErrorDetails.identifier,...
                             NewMessage.ErrorDetails.stack.file,...
                             NewMessage.ErrorDetails.stack.name,...
                             NewMessage.ErrorDetails.stack.line);
                end
            end

        end %function processMessage


        function StatusOk = openLogFile(obj,FileName,OpenType)

            % Was a file name passed in?
            if nargin<2
                FileName = obj.FileName;
            end
            if nargin<3
                OpenType = 'a';
            end

            % Try to open the new log file
            try
                [fid, Message] = fopen(FileName,OpenType);

                % If it failed to open, display a message
                if fid == -1
                    Message = sprintf('Unable to open log file ''%s'' for writing: %s\n',...
                        FileName, Message);
                    fid = [];
                end

            catch err
                % If another error occurred, display a message
                Message = sprintf('Unable to set log file ''%s'':\n %s\n',...
                    Value,err.Message);
                fid = [];
            end

            % Were there any errors?
            StatusOk = isempty(Message);
            if StatusOk
                % Set the new file ID
                obj.FileId = fid;
            else
                warning('Logger:OpenLogFile',...
                    'Unable to open log file ''%s''.\n',...
                    FileName);
            end

        end %function [fid, Message] = openFile(FileName)


        function closeLogFile(obj)

            % If a log file was open, close it
            if ~isempty(obj.FileId)
                Status = fclose(obj.FileId);
                % Warn if the file could not be closed
                if Status~=0
                    warning('Logger:CloseLogFile',...
                        'Unable to close log file ''%s''.\n',...
                        obj.LogFile);
                else
                    obj.FileId = [];
                end
            end

        end %function closeFile()

    end %protected methods


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Set Methods
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        % Set methods customize the behavior that occurs when a property value
        % is set.

        function set.LogFileLevel(obj,Value)

            % Validate the setting is one of the valid levels
            Value = validatestring(Value,obj.ValidLevels);
            obj.LogFileLevel = Value;

        end %function set.LogFileLevel


        function set.DisplayLevel(obj,Value)
            % Validate the setting is one of the valid levels
            Value = validatestring(Value,obj.ValidLevels);
            obj.DisplayLevel = Value;

        end %function set.DisplayLevel


        function set.LogFile(obj,Value)

            % Close the old log file
            closeLogFile(obj)

            % Open the new log file
            StatusOk = openLogFile(obj,Value);

            % Did it open the file successfully?
            if StatusOk
                % Keep the new log file name
                obj.LogFile = Value;
            else
                % If it failed to open, revert and don't change the file name
                openLogFile(obj);
            end

        end %function set.LogFile

    end %set methods

end %classdef
