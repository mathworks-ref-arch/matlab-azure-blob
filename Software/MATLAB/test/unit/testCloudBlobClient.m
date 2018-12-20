classdef testCloudBlobClient < matlab.unittest.TestCase
    % TESTCLOUDBLOBCLIENT Test Suite for the Cloud Blob Client
    % For testing the methods and use of the CloudBlobClient

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
        function testTearDown(testCase) %#ok<MANU>

        end
    end

    methods (Test)
        function testConstructor(testCase)
            disp('Running testConstructor');
            % Create the Client
            az = azure.storage.CloudStorageAccount;
            az.connect();

            % Create a client Object
            client = azure.storage.blob.CloudBlobClient(az);

            % Check that everything is kosher.
            testCase.verifyNotEmpty(client.Handle);
            testCase.verifyClass(client.Handle, 'com.microsoft.azure.storage.blob.CloudBlobClient');
            testCase.verifyTrue(client.isValid());
        end

        function testListAllContainers(testCase)
            disp('Running testListAllContainers');

            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();

            % Create a client Object
            client = azure.storage.blob.CloudBlobClient(az);
            contanerName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            container = azure.storage.blob.CloudBlobContainer(client,contanerName);
            container.createIfNotExists();

            % Get a list of containers
            containers = client.listContainers();

            % Since we don't know what exists on the service
            testCase.verifyClass(containers,'azure.storage.blob.CloudBlobContainer');

            % Cleanup
            container.deleteIfExists();
        end

    end

end
