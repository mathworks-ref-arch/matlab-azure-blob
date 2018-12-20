classdef testCloudBlobDirectory < matlab.unittest.TestCase
    % TESTCLOUDBLOBDIRECTORY This is a test stub for a unit testing
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

    % Copyright 2018 The MathWorks, Inc.

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
        function testConstructor1(testCase)
            disp('Running testConstructor1');
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();

            % Create a client Object
            client = azure.storage.blob.CloudBlobClient(az);
            contanerName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            container = azure.storage.blob.CloudBlobContainer(client,contanerName);
            cbdJ = container.Handle.getDirectoryReference([contanerName,'/']);
            % create based on a Java CloudBlobDirectory
            myDir = azure.storage.blob.CloudBlobDirectory(cbdJ);

            % Check that the blob directory is created as expected.
            testCase.verifyTrue(myDir.isValid());
            % note appended '/'
            testCase.verifyEqual(myDir.Name, [contanerName,'/']); % check if the lower is functional
            testCase.verifyClass(myDir.Name, 'char');

            flag = container.deleteIfExists();
            % the container does not really exist so expect false
            testCase.verifyFalse(flag);
            client.delete();
        end

        function testConstructor2(testCase)
            disp('Running testConstructor2');
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();

            % Create a client Object
            client = azure.storage.blob.CloudBlobClient(az);
            containerName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            container = azure.storage.blob.CloudBlobContainer(client,containerName);

            myDir = azure.storage.blob.CloudBlobDirectory(container, 'MyDirectoryName');

            % Check that the blob directory is created as expected.
            testCase.verifyTrue(myDir.isValid());
            % note appended '/'
            testCase.verifyEqual(myDir.Name, 'MyDirectoryName/'); % check if the lower is functional
            testCase.verifyClass(myDir.Name, 'char');

            flag = container.deleteIfExists();
            % the container does not really exist so expect false
            testCase.verifyFalse(flag);
            client.delete();
        end

        function testlistBlobs(testCase)
            disp('Running testlistBlobs');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();

            % Create a client Object
            azClient = azure.storage.blob.CloudBlobClient(az);
            % Create a container
            uniqName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            azContainer = azure.storage.blob.CloudBlobContainer(azClient,uniqName);
            flag = azContainer.createIfNotExists();
            testCase.verifyTrue(flag);

            myCloudBlobDirectory = azContainer.getDirectoryReference('mydirname');

            % List the contents of the CloudBlobDirectory should be an
            % empty cell array
            blobs = myCloudBlobDirectory.listBlobs();
            testCase.verifyEmpty(blobs);
            testCase.verifyTrue(isa(blobs,'cell'));

            filename = 'SampleData.mat';
            sampleData = rand(100,100);
            save(filename, 'sampleData');
            blob = azure.storage.blob.CloudBlockBlob(azContainer, [myCloudBlobDirectory.Name, filename], which(filename));
            blob.upload();

            % List the contents of the CloudBlobDirectory should be an
            % empty cell array
            blobs = myCloudBlobDirectory.listBlobs();
            testCase.verifyEqual(numel(blobs),1);
            testCase.verifyTrue(isa(blobs,'cell'));
            testCase.verifyTrue(isa(blobs{1},'azure.storage.blob.CloudBlockBlob'));
            testCase.verifyEqual(blobs{1}.Name,[myCloudBlobDirectory.Name, filename]);

            % clean up the resources created
            flag = azContainer.deleteIfExists();
            testCase.verifyTrue(flag);
            azClient.delete();
            delete(filename);
        end

        function testgets(testCase)
            disp('Running testgets');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();

            % Create a client Object
            azClient = azure.storage.blob.CloudBlobClient(az);
            % Create a container
            uniqName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            azContainer = azure.storage.blob.CloudBlobContainer(azClient,uniqName);
            flag = azContainer.createIfNotExists();
            testCase.verifyTrue(flag);

            myCloudBlobDirectory = azContainer.getDirectoryReference('mydirname');

            % List the contents of the CloudBlobDirectory should be an
            % empty cell array
            blobs = myCloudBlobDirectory.listBlobs();
            testCase.verifyEmpty(blobs);
            testCase.verifyTrue(isa(blobs,'cell'));

            filename = 'SampleData.mat';
            sampleData = rand(100,100);
            save(filename, 'sampleData');
            blob = azure.storage.blob.CloudBlockBlob(azContainer, [myCloudBlobDirectory.Name, filename], which(filename));
            blob.upload();

            testCase.verifyEqual(myCloudBlobDirectory.getPrefix, myCloudBlobDirectory.Name);
            testCase.verifyEmpty(myCloudBlobDirectory.getParent.Name);
            testCase.verifyTrue(isa(myCloudBlobDirectory.getParent,'azure.storage.blob.CloudBlobDirectory'));
            testCase.verifyEqual(myCloudBlobDirectory.getContainer.Name, azContainer.Name);

            myCloudBlobDirectory2 = azContainer.getDirectoryReference('mydirname/mydirname2');
            testCase.verifyEqual(myCloudBlobDirectory2.getParent.Name,'mydirname/');

            % clean up the resources created
            flag = azContainer.deleteIfExists();
            testCase.verifyTrue(flag);
            azClient.delete();
            delete(filename);
        end
    end

end
