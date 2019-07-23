classdef testCloudQueueClient < matlab.unittest.TestCase
    % TESTCLOUDQUEUECLIENT Test Suite for the Cloud Queue Client

    % Copyright 2019 The MathWorks, Inc.

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
            az.loadConfigurationSettings();
            az.connect();

            % Create a client Object
            client = az.createCloudQueueClient();

            testCase.verifyNotEmpty(client.Handle);
            testCase.verifyClass(client.Handle, 'com.microsoft.azure.storage.queue.CloudQueueClient');
            testCase.verifyNotEmpty(client.Handle);
        end

        function testQueues(testCase)
            disp('Running testQueues');
            % create the Client
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            queueClient = az.createCloudQueueClient();

            % create a queue
            qName = lower(['unittestqueue', char(javaMethod('randomUUID','java.util.UUID'))]);
            queue = queueClient.getQueueReference(qName);
            tf = queue.createIfNotExists();
            testCase.verifyTrue(tf);

            % list all queues
            queues = queueClient.listQueues();
            % there should be at least the queue that has just been created
            testCase.verifyGreaterThanOrEqual(numel(queues), 1);

            % list the queue with the prefix set to the queue name
            queues = queueClient.listQueues(qName);
            % there should be only the queue that has just been created
            testCase.verifyNumElements(queues, 1);
            testCase.verifyTrue(strcmp(queue.getName(), qName));
            testCase.verifyTrue(strcmp(queues(1).getName(), qName));
            testCase.verifyTrue(queue.exists());

            % create a client from the queue and use it
            serviceClient = queue.getServiceClient();
            queues = serviceClient.listQueues(qName);
            testCase.verifyNumElements(queues, 1);

            % create a message, add it and peek at it
            txtMsgStr = 'Hello World';
            nowIsh = datetime('now','TimeZone','UTC');
            message = azure.storage.queue.CloudQueueMessage(txtMsgStr);
            queue.addMessage(message);
            peekedMessage = queue.peekMessage();
            peekedContent = peekedMessage.getMessageContentAsString();
            testCase.verifyTrue(strcmp(peekedContent, txtMsgStr));

            % Download the approximate message count from the server
            % there should be only 1 message in the queue
            queue.downloadAttributes();
            cachedMessageCount = queue.getApproximateMessageCount();
            testCase.verifyEqual(cachedMessageCount, 1);

            % retrieve the first visible message in the queue & check it
            retrievedMessage = queue.retrieveMessage();
            retrievedContent = retrievedMessage.getMessageContentAsString();
            testCase.verifyTrue(strcmp(retrievedContent, txtMsgStr));

            % test PopReceipt
            receipt = retrievedMessage.getPopReceipt();
            testCase.verifyGreaterThan(numel(receipt), 0);
            testCase.verifyClass(receipt, 'char');

            % test dequeue
            count = retrievedMessage.getDequeueCount();
            testCase.verifyEqual(count, 1);

            % test IDs
            Id = retrievedMessage.getId();
            testCase.verifyClass(Id, 'char');
            messageId = retrievedMessage.getMessageId();
            testCase.verifyClass(messageId, 'char');
            testCase.verifyTrue(strcmp(messageId, Id));
            testCase.verifyNumElements(messageId, 36);

            % verify the expiration time is c. 1 week
            expT = retrievedMessage.getExpirationTime();
            expTimeDelta = seconds(expT - nowIsh);
            testCase.verifyEqual(expTimeDelta, 60*60*24*7, 'AbsTol',60);

            % verify the insertion time is c. now
            insT = retrievedMessage.getInsertionTime();
            insTimeDelta = seconds(insT - nowIsh);
            testCase.verifyEqual(insTimeDelta, 0, 'AbsTol',10);

            % verify that the visibility window is 30 seconds by default
            vizT = retrievedMessage.getNextVisibleTime();
            vizTimeDelta = seconds(vizT - nowIsh);
            testCase.verifyEqual(vizTimeDelta, 30, 'AbsTol', 10);

            % delete the message & check the message count has decremented
            queue.deleteMessage(retrievedMessage);
            queue.downloadAttributes();
            cachedMessageCount = queue.getApproximateMessageCount();
            testCase.verifyEqual(cachedMessageCount, 0);

            % test clear, check it is there, clear and check it is gone
            message = azure.storage.queue.CloudQueueMessage('dummyStr');
            message.setMessageContent(txtMsgStr);
            queue.addMessage(message);
            peekedMessage = queue.peekMessage();
            peekedContent = peekedMessage.getMessageContentAsString();
            testCase.verifyTrue(strcmp(peekedContent, txtMsgStr));
            queue.clear;
            peekedMessage = queue.peekMessage();
            testCase.verifyEmpty(peekedMessage);

            % test base64 message encoding
            tf = queue.getShouldEncodeMessage();
            testCase.verifyTrue(tf);
            queue.setShouldEncodeMessage(false);
            tf = queue.getShouldEncodeMessage();
            testCase.verifyFalse(tf);
            queue.setShouldEncodeMessage(true);
            tf = queue.getShouldEncodeMessage();
            testCase.verifyTrue(tf);

            % test byte array messages
            byteMsgVal = uint8('ABCD');
            message = azure.storage.queue.CloudQueueMessage(byteMsgVal);
            queue.addMessage(message);
            retrievedMessage = queue.retrieveMessage();
            byteArray = retrievedMessage.getMessageContentAsByte();
            testCase.verifyEqual(byteArray(1), uint8(65));
            testCase.verifyEqual(byteArray(2), uint8(66));
            testCase.verifyEqual(byteArray(3), uint8(67));
            testCase.verifyEqual(byteArray(4), uint8(68));
            queue.clear;
            % test using setMessageContent
            message = azure.storage.queue.CloudQueueMessage('dummyStr');
            byteMsgVal2 = uint8('EFGH');
            message.setMessageContent(byteMsgVal2);
            queue.addMessage(message);
            retrievedMessage = queue.retrieveMessage();
            byteArray = retrievedMessage.getMessageContentAsByte();
            testCase.verifyEqual(byteArray(1), uint8(69));
            testCase.verifyEqual(byteArray(2), uint8(70));
            testCase.verifyEqual(byteArray(3), uint8(71));
            testCase.verifyEqual(byteArray(4), uint8(72));

            % delete the queue, and check it is gone from the listing and that exists returns false
            tf = queue.deleteIfExists();
            testCase.verifyTrue(tf);
            queues = queueClient.listQueues(qName);
            testCase.verifyEmpty(queues);
            testCase.verifyFalse(queue.exists());

        end


        function testQueuePermissions(testCase)
            disp('Running testQueuePermissions');
            % create the Client
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            queueClient = az.createCloudQueueClient();

            % create a queue
            qName = lower(['unittestqueue', char(javaMethod('randomUUID','java.util.UUID'))]);
            queue = queueClient.getQueueReference(qName);
            tf = queue.createIfNotExists();
            testCase.verifyTrue(tf);

            % check the storageUri & uri
            storageUri = queue.getStorageUri();
            testCase.verifyClass(storageUri, 'azure.storage.StorageUri');
            testCase.verifyTrue(strcmp(char(storageUri.PrimaryUri.EncodedPath), ['/',qName]));
            testCase.verifyTrue(strcmp(char(storageUri.SecondaryUri.EncodedPath), ['/',qName]));
            uri = queue.getUri();
            testCase.verifyClass(uri, 'matlab.net.URI');
            testCase.verifyTrue(strcmp(char(uri.EncodedPath), ['/',qName]));

            % set metadata & check it locally
            metadata = queue.getMetadata();
            testCase.verifyEmpty(metadata);
            metadataCM = containers.Map({'key1'},{'val1'});
            queue.setMetadata(metadataCM);
            metadata = queue.getMetadata();
            testCase.verifyEqual(metadata.Count, uint64(1));
            k = keys(metadata);
            v = values(metadata);
            testCase.verifyTrue(strcmp(v{1}, 'val1'));
            testCase.verifyTrue(strcmp(k{1}, 'key1'));
            % upload the metadata and check it again with a fresh
            % queueClient using the same queue
            queue.uploadMetadata();
            queue2 = queueClient.getQueueReference(queue.getName);
            queue2.downloadAttributes();
            metadata2 = queue2.getMetadata();
            testCase.verifyEqual(metadata2.Count, uint64(1));
            k = keys(metadata2);
            v = values(metadata2);
            testCase.verifyTrue(strcmp(v{1}, 'val1'));
            testCase.verifyTrue(strcmp(k{1}, 'key1'));

            % check policies
            perms = queue.downloadPermissions();
            sharedAccessPolicies = perms.getSharedAccessPolicies();
            testCase.verifyEqual(sharedAccessPolicies.Count, uint64(0));

            % set a policy for a SAS
            policy = azure.storage.queue.SharedAccessQueuePolicy();
            permSet(1) = azure.storage.queue.SharedAccessQueuePermissions.READ;
            policy.setPermissions(permSet);
            t1 = datetime('now','TimeZone','UTC') + hours(24);
            policy.setSharedAccessExpiryTime(t1);
            t2 = datetime('now','TimeZone','UTC') - minutes(15);
            policy.setSharedAccessStartTime(t2);
            % get a SAS
            % set a policy id string as a basic test
            groupPolicyIdentifier = 'myGroupPolicyId';
            sasToken = queue.generateSharedAccessSignature(policy, groupPolicyIdentifier);
            testCase.verifyTrue(contains(sasToken, groupPolicyIdentifier));
            % reset policy Id to '' as there is not one set to use,
            % regenerate the token
            groupPolicyIdentifier = '';
            sasToken = queue.generateSharedAccessSignature(policy, groupPolicyIdentifier);
            resourceUri = queue.getUri();
            sasUri = [char(resourceUri.EncodedURI), '?', sasToken];
            % use the SAS to create a queue
            sasQueue = azure.storage.queue.CloudQueue(azure.storage.StorageUri(matlab.net.URI(sasUri)));
            testCase.verifyTrue(sasQueue.exists());
            % read from the queue
            peekedMessage = sasQueue.peekMessage();
            testCase.verifyEmpty(peekedMessage);
            % check for no add rights
            message = azure.storage.queue.CloudQueueMessage('will not work');
            try
                sasQueue.addMessage(message);
            catch e
                e.message
                if (isa(e,'matlab.exception.JavaException'))
                    ex = e.ExceptionObject;
                    assert(isjava(ex));
                    ex.printStackTrace;
                end
            end
            testCase.verifyTrue(contains(e.message, 'This request is not authorized to perform this operation using this permission'));

            % build a permissions array
            policyArray(1) = azure.storage.queue.SharedAccessQueuePolicy();
            % create an array of permissions enumerations
            permSet(1) = azure.storage.queue.SharedAccessQueuePermissions.ADD;
            permSet(2) = azure.storage.queue.SharedAccessQueuePermissions.READ;
            permSet(3) = azure.storage.queue.SharedAccessQueuePermissions.UPDATE;
            policyArray(1).setPermissions(permSet);
            startTime = datetime('now','TimeZone','UTC') - minutes(15);
            policyArray(1).setSharedAccessStartTime(startTime);
            % 2nd entry
            policyArray(2) = azure.storage.queue.SharedAccessQueuePolicy();
            % create an array of permissions enumerations
            permSet(1) = azure.storage.queue.SharedAccessQueuePermissions.ADD;
            permSet(2) = azure.storage.queue.SharedAccessQueuePermissions.READ;
            policyArray(2).setPermissions(permSet);
            endTime = datetime('now','TimeZone','UTC') + hours(24);
            policyArray(2).setSharedAccessStartTime(endTime);
            % create queue permissions and upload them
            permissions = azure.storage.queue.QueuePermissions();
            permissions.setSharedAccessPolicies(policyArray);
            queue.uploadPermissions(permissions);

            % download non empty permissions
            permissionsDownloaded = queue.downloadPermissions();
            sharedAccessPolicies = permissionsDownloaded.getSharedAccessPolicies();
            testCase.verifyEqual(sharedAccessPolicies.Count, uint64(2));

            % delete the queue
            tf = queue.deleteIfExists();
            testCase.verifyTrue(tf);
            testCase.verifyFalse(queue.exists());
        end


        function testMessageUpdate(testCase)
            disp('Running testMessageUpdate');
            % create the Client
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            queueClient = az.createCloudQueueClient();

            % create a queue
            qName = lower(['unittestqueue', char(javaMethod('randomUUID','java.util.UUID'))]);
            queue = queueClient.getQueueReference(qName);
            tf = queue.createIfNotExists();
            testCase.verifyTrue(tf);

            % add initial message to the queue
            originalMsgStr = 'Hello World';
            newMsgStr = 'Updated content';
            message = azure.storage.queue.CloudQueueMessage(originalMsgStr);
            queue.addMessage(message);

            retrievedMessage = queue.retrieveMessage();
            retrievedContent = retrievedMessage.getMessageContentAsString();
            testCase.verifyTrue(strcmp(retrievedContent, originalMsgStr));

            retrievedMessage.setMessageContent(newMsgStr);
            requestOptions = azure.storage.queue.QueueRequestOptions();
            operationContext = azure.storage.OperationContext();
            updateFields(1) = azure.storage.queue.MessageUpdateFields.CONTENT;
            updateFields(2) = azure.storage.queue.MessageUpdateFields.VISIBILITY;
            visibilityTimeout = 10;
            queue.updateMessage(retrievedMessage, visibilityTimeout, updateFields, requestOptions, operationContext);

            % retrieve the message straight away, this should fail as not
            % yet visible
            retrievedMessage2 = queue.retrieveMessage();
            testCase.verifyEmpty(retrievedMessage2);

            % wait 10 seconds plus margin and then it should be visible
            pause(visibilityTimeout + 2);
            retrievedMessage2 = queue.retrieveMessage();
            retrievedContent2 = retrievedMessage2.getMessageContentAsString();
            testCase.verifyTrue(strcmp(retrievedContent2, newMsgStr));

            % change just the visibility window
            queue.updateMessage(retrievedMessage2, visibilityTimeout);
            pause(visibilityTimeout + 2);
            retrievedMessage2 = queue.retrieveMessage();
            retrievedContent2 = retrievedMessage2.getMessageContentAsString();
            testCase.verifyTrue(strcmp(retrievedContent2, newMsgStr));

            % delete the queue
            tf = queue.deleteIfExists();
            testCase.verifyTrue(tf);
            testCase.verifyFalse(queue.exists());
        end
    end
end
