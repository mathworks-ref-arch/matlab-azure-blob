# Logging - controlling command output
The interface uses a logging framework which is similar in many regards to the well known log4j framework. It supports logging levels of:
* verbose - detailed messages that are useful during development and testing but are likely to be too detailed in day-to-day usage.
* debug - default level with minimal output, recommended as a default output level.
* warning - warnings indicative of potential problems, messages are displayed in red in the style of a built in MATLAB® warnings.
* error - error messages with critical problems, messages trigger stack trace like output and execution is halted.

The default console logging level is *debug*. The logging library can log to both the MATLAB console and to a file. By default it logs to the MATLAB console only. One can set the levels used for logging separately for both, thus one could log in detail to a file and in less detail to the console and consult the detailed log only for postmortem purposes.

Once a cloud storage account or client object, which create a singleton logger object, have been created one can change the default values as follows:
```
logObj = Logger.getLogger();
logObj.DisplayLevel = 'verbose';
write(logObj,'verbose','My verbose message');
My verbose message
```

To enable logging to a file a log file path and name must be set:
```
% provide a name path for a log file
logObj.LogFile = 'MyLogFile.log';

% set the log level for the log file
logObj.LogFileLevel = 'verbose';
```
By default a filename is *not* set and no log file is produced. The logging level used in the file output can be set independently as shown. By default this level is set to *warning*.


Logger methods are:
* clearMessages(obj) - Clears the log messages currently stored in the Logger object.
* clearLogFile(obj) - Clears the log messages currently stored in the log file.
* write(obj,Level,MessageText) - Writes a message to the log.

Logger variables are:
* LogFileLevel - The level of log messages that will be saved to the log file.
* DisplayLevel - The level of log messages that will be displayed in the command window.
* LogFile - The file name or path to the log file. If empty, nothing will be logged to file.
* Messages - Structure array containing log messages.
* MsgPrefix - This message prefix may be used in error logging if an errorStruct identifier is not set.

The errorStruct identifier is a character vector that specifies a component and a mnemonic label for an error or warning. The format of a simple identifier is: component:mnemonic

A colon separates the two parts of the identifier: component and mnemonic. If the identifier uses more than one component, then additional colons are required to separate them. A message identifier must always contain at least one colon, e.g:
* MATLAB:rmpath:DirNotFound
* MATLAB:odearguments:InconsistentDataType.

Both the component and mnemonic fields must adhere to the following syntax rules:
* No white space (space or tab characters) is allowed anywhere in the identifier.
* The first character must be alphabetic, either uppercase or lowercase.
* The remaining characters can be alphanumeric or an underscore.
* There is no length limitation to either the component or mnemonic.
* The identifier can also be an empty character vector.

Messages logged to the console with a level of warning are displayed as if they were native MATLAB warnings and similarly error level messages are displayed as if they were native errors.

For full details see: */Software/MATLAB/app/functions/Logger.m*.


----------------

[//]: #  (Copyright 2017, The MathWorks, Inc.)
