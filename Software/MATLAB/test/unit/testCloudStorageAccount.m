classdef testCloudStorageAccount < matlab.unittest.TestCase
    % TESTCLOUDSTORAGEACCOUNT Unit test for the CloudStorageAccount object
    % This test suite exercises the methods to connect to the
    % CloudStorageObject
    %
    %   run(testCloudStorageAccount)

    % The assertions that you can use in your test cases:
    %
    %    assertTrue
    %    assertFalse
    %    assertEqual
    %    assertFilesEqual
    %    assertElementsAlmostEqual
    %    assertVectorsAlmostEqual
    %    assertExceptionThrown

    % Copyright 2016 The MathWorks, Inc.

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
        function testTearDown(testCase)

        end
    end

    methods (Test)
        %% TEST CASE: Constructor for the object
        function testAzureStorageAccountConstructor(testCase)
            disp('Running testAzureStorageAccountConstructor');
            % Exercise the constructor and Getter on the URI dependent
            % property through all the code paths
            azObj = azure.storage.CloudStorageAccount;
            azObj.UseDevelopmentStorage = false;
            testCase.verifyEqual(class(azObj.URI),'char');
            azObj.UseDevelopmentStorage = true;
            testCase.verifyEqual(class(azObj.URI),'char');
            azObj.Secondary = false;
            testCase.verifyEqual(class(azObj.URI),'char');
            azObj.Secondary = true;
            testCase.verifyEqual(class(azObj.URI),'char');

            % Finally ensure that we have the right object - almost
            % redundant at this point
            testCase.verifyClass(azObj,'azure.storage.CloudStorageAccount');
        end


        %% TEST CASE: Construction of the storage string
        function testConnectionStringMethods(testCase)
            disp('Running testConnectionStringMethods');
            % Connect to the storage
            az = azure.storage.CloudStorageAccount;

            % Assert that we get some sort of char array on return
            testCase.verifyClass(az.getStorageConnectionString(),'char');
        end

        %% TEST CASE: Connection to the storage library
        function testConnection(testCase)
            disp('Running testConnection');
            % Create the connection
            % Create the object
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect;

            testCase.verifyClass(az.Handle, 'com.microsoft.azure.storage.CloudStorageAccount');
            testCase.verifyTrue(az.isValid());
        end

        %% Create a blob client
        function testBlobClient(testCase)
            disp('Running testBlobClient');
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            bc = az.getCloudBlobClient();

            testCase.verifyClass(bc,'azure.storage.blob.CloudBlobClient');
        end

        %% Create a table api client
        function testTableClient(testCase)
            disp('Running testTableClient');
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            tc = az.getCloudTableClient();

            testCase.verifyClass(tc,'azure.storage.table.CloudTableClient');
        end


    end

end
