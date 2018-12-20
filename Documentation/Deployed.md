#  Use with MATLAB Production Server and MATLAB Compiler

When using the interface with MATLAB Production Server™ or MATLAB Compiler™ one normally uses the respective and superficially similar Compiler GUIs. There are three points to notes when deploying applications in this way:    
1. Paths are normally configured using the startup.m script in the */Software/MATLAB* directory. When deploying an application that calls this package the paths are not configured in that way and the startup script will have no effect. No end user action is required in this regard.    
2. Once compiled a .jar file can be found in */Software/MATLAB/lib/jar/target/*, this file includes the required functionality from the Microsoft® Java® SDK. The automatic dependency analysis will not pick this up and it must be added manually.
3. For testing purposes adding a credentials json file manually, as per the jar file, is a simple way to include credentials in a way that will be easily found by the deployed code. While the json file will be encrypted it will be included in the MATLAB Compiler output which may be shared. This may well violate local security polices and best practice. One should consider other approaches to providing credentials to deployed applications. One should also consider the overall compiling and deployment process and avoid a scenario which involves credentials being included in source code repositories where they may be exposed.

------------

[//]: #  (Copyright 2017, The MathWorks, Inc.)
