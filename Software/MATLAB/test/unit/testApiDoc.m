classdef testApiDoc < matlab.unittest.TestCase
    % TESTOBJECT This is a test stub for a unit testing
    % The assertions that you can use in your test cases:
    %
    %    assertTrue
    %    assertFalse
    %    assertEqual
    %    assertFilesEqual
    %    assertElementsAlmostEqual
    %    assertVectorsAlmostEqual
    %    assertExceptionThrown
    %
    %   A more detailed explanation goes here.
    %
    % Notes:

    % Copyright 2017 The MathWorks, Inc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     properties
        logObj
     end

     methods (TestMethodSetup)
        function testSetup(testCase)
            testCase.logObj = Logger.getLogger();
            testCase.logObj.DisplayLevel = 'verbose';
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>

        end
    end

    methods (Test)
        function testgenApiDoc(testCase)
            disp('Running testgenApiDoc');
            % Test that a freshly generated API document matches the
            % current one

            % get the location of the existing doc we want to diff against
            % documentation not likely to be on the path
            currentFolder = pwd;
            pathParts = split(currentFolder, filesep);
            azDir = '';
            for i = 1:length(pathParts)-4
                azDir = [char(azDir),char(pathParts(i)),filesep];
                % azDir will have a trailing filesep
            end
            documentationDir = [azDir,'Documentation'];
            apiDocFull = [documentationDir,filesep,'AzureWASBApi.md'];

            % check the file we want to test exists
            testCase.verifyTrue(exist(apiDocFull, 'file') == 2);

            % create a temp file and generate a new version of the API doc
            % verify that the generation worked also
            % The utilities directory is
            % not likely to be on the path if not add it
            tempDocFull = [tempname,'.md'];
            whichVal = which('generateApiDoc');
            if isempty(whichVal)
                utilitiesDir = [azDir,'Software',filesep,'utilities'];
                utilitiesPath = genpath(utilitiesDir);
                addpath(utilitiesPath);
            end
            % to reduce the chance of misplaced files generateApiDoc only
            % generates in the /Documentation/Storage/WASB directory so only
            % need to pass it the filename here
            genDocTf = generateApiDoc(tempDocFull);
            if ~genDocTf
                write(testCase.logObj,'warning',['Error generating API Doc: ',tempDocFull]);
            end
            testCase.verifyTrue(genDocTf);

            % diff the new and old files and check for no differences
            % debug putput
            % fprintf('tempDocFull: %s\n',tempDocFull);
            % fprintf('apiDocFull: %s\n',apiDocFull);
            diffOutput = visdiff(tempDocFull,apiDocFull);
            % visdiff should output the follow string in the html output if
            % the files match
            if contains(diffOutput,'<div>The files are identical.</div>')
                write(testCase.logObj,'debug','Azure WASB API documentation is up to date');
                diffResult = true;
            else
                write(testCase.logObj,'warning','Azure WASB API documentation is NOT up to date');
                % debug output
                write(testCase.logObj,'verbose',['visdiff output: ',diffOutput]);
                diffResult = false;
            end
            % delete the temp file
            delete(tempDocFull);
            % if the files don't match fail the test to flag that the api
            % doc needs to be regenerated
            testCase.verifyTrue(diffResult);

        end
    end
end
