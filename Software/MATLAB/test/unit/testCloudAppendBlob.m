classdef testCloudAppendBlob < matlab.unittest.TestCase
    % TESTCLOUDAppendBLOB This is a test stub for a unit testing
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
        function testAppendText(testCase)
            disp('Running testAppendText');
            az = azure.storage.CloudStorageAccount;
            az.UseDevelopmentStorage = false;
            az.loadConfigurationSettings();
            az.connect();
            azClient = azure.storage.blob.CloudBlobClient(az);

            % Create a container
            uniqName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            azContainer = azure.storage.blob.CloudBlobContainer(azClient,uniqName);
            flag = azContainer.createIfNotExists();
            testCase.verifyTrue(flag);

            % Create some sample data & upload it as an CloudAppendBlob
            filename1 = [tempname,'.txt'];
            fileID = fopen(filename1,'w');
            testCase.verifyGreaterThan(fileID, 0);
            fprintf(fileID,'ABCD');
            fclose(fileID);
            blob = azContainer.getAppendBlobReference(filename1);
            blob.upload();
            
            % Download the blob an check its contents
            filename2 = [tempname,'.txt'];
            blob.download(filename2);
            fileID = fopen(filename2,'r');
            testCase.verifyGreaterThan(fileID, 0);
            step1Str = fgets(fileID);
            fclose(fileID);
            testCase.verifyTrue(strcmp(step1Str, 'ABCD'));
            
            % Append some text and download again
            blob.appendText('EFGH');
            filename3 = [tempname,'.txt'];
            blob.download(filename3);
            fileID = fopen(filename3,'r');
            testCase.verifyGreaterThan(fileID, 0);
            step2Str = fgets(fileID);
            fclose(fileID);
            testCase.verifyTrue(strcmp(step2Str, 'ABCDEFGH'));
            
            % Append some text from a file
            filename4 = [tempname,'.txt'];
            fileID = fopen(filename4,'w');
            testCase.verifyGreaterThan(fileID, 0);
            fprintf(fileID,'IJKL');
            fclose(fileID);
            blob.appendFromFile(filename4);
            filename5 = [tempname,'.txt'];
            blob.download(filename5);
            fileID = fopen(filename5,'r');
            testCase.verifyGreaterThan(fileID, 0);
            step3Str = fgets(fileID);
            fclose(fileID);
            testCase.verifyTrue(strcmp(step3Str, 'ABCDEFGHIJKL'));
            
            % Clean up the resources created
            flag = azContainer.deleteIfExists();
            testCase.verifyTrue(flag);
            azClient.delete();
            delete(filename1);
            delete(filename2);
            delete(filename3);
            delete(filename4);
            delete(filename5);
        end
        
        function testlistBlobsOne(testCase)
            disp('Running testlistBlobsOne');
            % Test listing A blob
            % Create a client
            az = azure.storage.CloudStorageAccount;
            az.UseDevelopmentStorage = false;
            az.loadConfigurationSettings();
            az.connect();
            azClient = azure.storage.blob.CloudBlobClient(az);

            % Create a container
            uniqName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            azContainer = azure.storage.blob.CloudBlobContainer(azClient,uniqName);
            flag = azContainer.createIfNotExists();
            testCase.verifyTrue(flag);

            % Create some sample data & upload them
            filename = 'SampleData.mat';
            sampleData = rand(100,100); %#ok<NASGU>
            save(filename, 'sampleData');
            blob = azContainer.getAppendBlobReference(which(filename));
            blob.upload();

            % list the blob and check the filename matches
            blobList = azContainer.listBlobs();
            testCase.verifyEqual(blobList{1}.Name,filename);
            testCase.verifyEqual(class(blobList{1}),'azure.storage.blob.CloudAppendBlob');
            testCase.verifyEqual(numel(blobList),1);

            % clean up the resources created
            flag = azContainer.deleteIfExists();
            testCase.verifyTrue(flag);
            azClient.delete();
            delete(filename);
        end


        function testlistBlobsMany(testCase)
            disp('Running testlistBlobsMany');
            % Test listing several blobs
            % Create a client
            az = azure.storage.CloudStorageAccount;
            az.UseDevelopmentStorage = false;
            az.loadConfigurationSettings();
            az.connect();
            azClient = azure.storage.blob.CloudBlobClient(az);

            % Create a container
            uniqName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            azContainer = azure.storage.blob.CloudBlobContainer(azClient,uniqName);
            flag = azContainer.createIfNotExists();
            testCase.verifyTrue(flag);

            % Create some sample data & upload them
            filename1 = 'SampleData1.mat';
            filename2 = 'SampleData2.mat';
            filename3 = 'SampleData3.mat';
            sampleData = rand(100,100); %#ok<NASGU>
            save(filename1, 'sampleData');
            save(filename2, 'sampleData');
            save(filename3, 'sampleData');
            blob = azContainer.getAppendBlobReference(which(filename1));
            blob.upload();
            blob = azContainer.getAppendBlobReference(which(filename2));
            blob.upload();
            blob = azContainer.getAppendBlobReference(which(filename3));
            blob.upload();

            % list the blobs and check the filenames matches
            blobList = azContainer.listBlobs();
            testCase.verifyEqual(class(blobList{1}),'azure.storage.blob.CloudAppendBlob');

            testCase.verifyEqual(blobList{1}.Name,filename1);
            testCase.verifyEqual(blobList{2}.Name,filename2);
            testCase.verifyEqual(blobList{3}.Name,filename3);

            % clean up the resources created
            flag = azContainer.deleteIfExists();
            testCase.verifyTrue(flag);
            azClient.delete();
            delete(filename1);
            delete(filename2);
            delete(filename3);
        end

        function testlistBlobDir(testCase)
            disp('Running testlistBlobDir');
            % Test listing with directories
            % Create a client
            az = azure.storage.CloudStorageAccount;
            az.UseDevelopmentStorage = false;
            az.loadConfigurationSettings();
            az.connect();
            azClient = azure.storage.blob.CloudBlobClient(az);
            delimiter = azClient.DirectoryDelimiter;

            % Create a container
            uniqName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            azContainer = azure.storage.blob.CloudBlobContainer(azClient,uniqName);
            flag = azContainer.createIfNotExists();
            testCase.verifyTrue(flag);

            % Create some sample data and upload it creating a virtual directory
            sampleData = rand(100,100); %#ok<NASGU>
            filename1 = 'SampleData1.mat';
            save(filename1, 'sampleData');
            fullpath = which(filename1);

            newName = ['mydir', delimiter, 'mynewname.mat'];
            myblob = azure.storage.blob.CloudAppendBlob(azContainer, newName, fullpath);
            myblob.upload;

            % list the blobs and check dir is listed and name matches
            containerBlobList = azContainer.listBlobs();
            testCase.verifyEqual(containerBlobList{1}.Name, ['mydir',delimiter]);

            % the name should be the virtual directory and the file
            directoryBlobList = containerBlobList{1}.listBlobs();
            testCase.verifyEqual(directoryBlobList{1}.Name, newName);

            % Clean up
            flag = azContainer.deleteIfExists();
            testCase.verifyTrue(flag);
            azClient.delete();
            delete(filename1);
        end

    end

end
