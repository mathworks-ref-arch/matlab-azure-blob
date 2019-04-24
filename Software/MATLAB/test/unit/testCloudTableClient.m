classdef testCloudTableClient < matlab.unittest.TestCase
    % TESTCLOUDTABLECLIENT This is a test stub for a unit testing
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
    % This tests the CloudTableClient and associated functionality.
    
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
            % Logger prefix of Azure Data Lake Store Interface, can be used when catching errors
            testCase.logObj.MsgPrefix = 'Azure:WASB';
        end
    end
    
    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>
            
        end
    end
    
    methods (Test)
        
        function testConstructor(testCase)
            disp('Running testConstructor');
            % Create a table client
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            tc = azure.storage.table.CloudTableClient(az);
            
            testCase.assertClass(tc,'azure.storage.table.CloudTableClient');
            
        end
        
        function testCreateTableReferences(testCase)
            disp('Running testCreateTableReferences');
            % Create a handle to the Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            
            % Create a client and table handle
            client = azure.storage.table.CloudTableClient(az);
            tbl = client.getTableReference('SampleTable');
            
            testCase.assertClass(tbl,'azure.storage.table.CloudTable');
            testCase.assertNotEmpty(tbl.Handle);
            
            tbls = client.getTableReference({'Table1','Table2'});
            testCase.assertEqual(numel(tbls),2);
            testCase.assertNotEmpty(tbls(1).Handle);
            testCase.assertNotEmpty(tbls(2).Handle);
            
            % Cleanup
            client.delete();
        end
        
        function testExistenceChecks(testCase)
            disp('Running testExistenceChecks');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableExistenceChecks');
            
            % Create a table
            tableHandle.createIfNotExists();
            
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Cleanup
            % Delete the table
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testSingleInsertOrReplace(testCase)
            disp('Running testSingleInsertOrReplace');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableSingleInsertOrReplace');
            
            % Create a table
            tableHandle.createIfNotExists();
            
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a sample entity and insert into the database
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('Name');
            dynamicEntity.Name = 'john';
            dynamicEntity.partitionKey = 'pk';
            dynamicEntity.rowKey = ['rk',datestr(now)];
            dynamicEntity.initialize();
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testBatchInsertOrReplace(testCase)
            disp('Running testBatchInsertOrReplace');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableBatchInsertOrReplace');
            
            % Create a table
            tableHandle.createIfNotExists();
            
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a number of sample entity and insert into the database
            batchSize = 100; % 100 is a hard limit
            for bCount = 1:batchSize
                dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity;
                dynamicEntity(bCount).addprop('Name');
                dynamicEntity(bCount).Name = ['john',num2str(bCount)];
                dynamicEntity(bCount).partitionKey = 'pk';
                dynamicEntity(bCount).rowKey = ['rk',num2str(bCount),datestr(now)];
                dynamicEntity(bCount).initialize();
            end
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity); % vectorized
            tableHandle.execute(tableOperation);
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testBatchInsertOrMerge(testCase)
            disp('Running testBatchInsertOrMerge');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableBatchInsertOrMerge');
            
            % Create a table
            tableHandle.createIfNotExists();
            
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a number of sample entity and insert into the database
            batchSize = 100; % 100 is a hard limit
            for bCount = 1:batchSize
                dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity;
                dynamicEntity(bCount).addprop('Name');
                dynamicEntity(bCount).Name = ['john',num2str(bCount)];
                dynamicEntity(bCount).partitionKey = 'pk';
                dynamicEntity(bCount).rowKey = ['rk',num2str(bCount),datestr(now)];
                dynamicEntity(bCount).initialize();
            end
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrMerge(dynamicEntity); % vectorized
            tableHandle.execute(tableOperation);
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testBatchInsertWithAndWithoutEcho(testCase)
            disp('Running testBatchInsertWithAndWithoutEcho');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandleEcho = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestInsertTestEchoTable');
            tableHandleNoEcho = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestInsertTestNoEchoTable');
            % Create a table
            tableHandleEcho.createIfNotExists();
            tableHandleNoEcho.createIfNotExists();
            
            % Check if the table exists
            flag = tableHandleEcho.exists();
            testCase.assertTrue(flag);
            flag = tableHandleNoEcho.exists();
            testCase.assertTrue(flag);
            
            % Create a number of sample entity and insert into the database
            batchSize = 10; % 100 is a hard limit
            for bCount = 1:batchSize
                dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity; %#ok<*AGROW>
                dynamicEntity(bCount).addprop('Name');
                dynamicEntity(bCount).Name = ['john',num2str(bCount)];
                dynamicEntity(bCount).partitionKey = 'pk';
                dynamicEntity(bCount).rowKey = ['rk',num2str(bCount),datestr(now)];
                dynamicEntity(bCount).initialize();
            end
            
            % Create a table operation to execute on the database with and
            % without the echo
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity(1:5),true); % vectorized
            tableHandleEcho.execute(tableOperation);
            
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity(6:10),false); % vectorized
            tableHandleNoEcho.execute(tableOperation);
            % TODO add validation
            
            
            % Cleanup
            flag = tableHandleEcho.deleteIfExists();
            testCase.assertTrue(flag);
            flag = tableHandleNoEcho.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testBatchInsertAndDelete(testCase)
            disp('Running testBatchInsertAndDelete');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandleEcho = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestinsertdeletetable');
            
            % Create a table
            tableHandleEcho.createIfNotExists();
            
            % Check if the table exists
            flag = tableHandleEcho.exists();
            testCase.assertTrue(flag);
            
            % Create a number of sample entity and insert into the database
            batchSize = 10; % 100 is a hard limit
            for bCount = 1:batchSize
                dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity; %#ok<*AGROW>
                dynamicEntity(bCount).addprop('Name');
                dynamicEntity(bCount).Name = ['john',num2str(bCount)];
                dynamicEntity(bCount).partitionKey = 'pk';
                dynamicEntity(bCount).rowKey = ['rk',num2str(bCount),datestr(now)];
                dynamicEntity(bCount).initialize();
            end
            
            % Create a table operation to execute on the database with and
            % without the echo
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity,true); % vectorized
            tableHandleEcho.execute(tableOperation);
            
            % Now delete the data
            tableOperation = azure.storage.table.TableOperation.delete(dynamicEntity); % vectorized
            tableHandleEcho.execute(tableOperation);
            
            % Cleanup
            flag = tableHandleEcho.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testMerge(testCase)
            disp('Running testMerge');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestDelete');
            
            % Create a table
            tableHandle.createIfNotExists();
            
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a number of sample entities and insert into the database
            % 100 is a hard limit (see notes below)
            
            batchSize = 100;
            for bCount = 1:batchSize
                dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity;
                dynamicEntity(bCount).addprop('Name');
                dynamicEntity(bCount).Name = ['john',num2str(bCount)];
                dynamicEntity(bCount).partitionKey = 'pk';
                dynamicEntity(bCount).rowKey = ['rk',num2str(bCount),datestr(now)];
                dynamicEntity(bCount).initialize();
            end
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity, true); % vectorized
            tableHandle.execute(tableOperation);
            
            % Now let us add additional properties to each entry
            for bCount = 1:batchSize
                mergedEntity(bCount) = dynamicEntity(bCount);
                mergedEntity(bCount).addprop('Location');
                mergedEntity(bCount).Location = ['RandomCity',num2str(bCount)];
                % Don't change the rowkey or the partition key so that we
                % can merge this correctly
                mergedEntity(bCount).initialize();
            end
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.merge(dynamicEntity); % vectorized
            tableHandle.execute(tableOperation);
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testReplace(testCase)
            disp('Running testReplace');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestReplace');
            
            % Create a table
            tableHandle.createIfNotExists();
            
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a number of sample entities and insert into the database
            % 100 is a hard limit (see notes below)
            
            batchSize = 100;
            for bCount = 1:batchSize
                dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity;
                dynamicEntity(bCount).addprop('Name');
                dynamicEntity(bCount).Name = ['john',num2str(bCount)];
                dynamicEntity(bCount).partitionKey = 'pk';
                dynamicEntity(bCount).rowKey = ['rk',num2str(bCount),datestr(now)];
                dynamicEntity(bCount).initialize();
            end
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity, true); % vectorized
            tableHandle.execute(tableOperation);
            
            % Now let us add additional properties to each entry
            for bCount = 1:batchSize
                replaceEntity(bCount) = dynamicEntity(bCount);
                replaceEntity(bCount).addprop('Location');
                replaceEntity(bCount).Location = ['RandomCity',num2str(bCount)];
                % Don't change the rowkey or the partition key so that we
                % can replace this correctly
                replaceEntity(bCount).initialize();
            end
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.replace(dynamicEntity); % vectorized
            tableHandle.execute(tableOperation);
            
            % TODO: Verify that the table has the right replaced entities
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testBasicRetrieve(testCase)
            disp('Running testBasicRetrieve');
            import java.util.UUID;
            
            % Use the storage account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            
            % To create a client
            client = az.getCloudTableClient();
            
            % Create a tableHandle
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestBasicRetrieve');
            
            % Insert some partitioned data
            tableHandle.createIfNotExists();
            
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a unique row
            uuid = char(UUID.randomUUID());
            testSignature = ['john',uuid];
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('Name');
            dynamicEntity.Name = testSignature;
            dynamicEntity.addprop('Value');
            dynamicEntity.Value = 'Sample';
            dynamicEntity.partitionKey = 'pk';
            dynamicEntity.rowKey = ['rk', uuid];
            dynamicEntity.initialize();
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity, true); % vectorized
            tableHandle.execute(tableOperation);
            
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            
            % Fetch the first inserted element
            pk = dynamicEntity.partitionKey;
            rk = dynamicEntity.rowKey;
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            
            % Assert the element that was fetched the one that was inserted
            testCase.assertEqual(results.Name, testSignature);
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        %% Test to retrieve a particular partition defined by a partionkey
        function testPartitionRetrieve(testCase)
            disp('Running testPartitionRetrieve');
            % Java import - used to create dummy data
            import java.util.UUID;
            
            % Use the storage account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            
            % To create a client
            client = az.getCloudTableClient();
            
            % Create a tableHandle
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestPartition');
            
            % Insert some partitioned data
            tableHandle.createIfNotExists();
            
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a number of sample entities and insert into the database
            % 100 is a hard limit (see notes below)
            % Partition them appropriately modulo 20
            batchSize = 100;
            partitionSize = 20;
            for bCount = 1:batchSize
                dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity;
                dynamicEntity(bCount).addprop('Name');
                dynamicEntity(bCount).Name = ['john',num2str(bCount)];
                dynamicEntity(bCount).partitionKey = ['pk', num2str(ceil(bCount/partitionSize))];
                dynamicEntity(bCount).rowKey = ['rk', char(UUID.randomUUID())];
                dynamicEntity(bCount).addprop('Value');
                dynamicEntity(bCount).Value = rand(1,1);
                dynamicEntity(bCount).initialize();
            end
            
            % Create a table operation to execute on the database and
            % insert the entities partition at a time since the batched
            % operation imposes that limitation that all entities need to
            % have the same partition key.
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity(1:20), true); % vectorized
            tableHandle.execute(tableOperation);
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity(21:40), true); % vectorized
            tableHandle.execute(tableOperation);
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity(41:60), true); % vectorized
            tableHandle.execute(tableOperation);
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity(61:80), true); % vectorized
            tableHandle.execute(tableOperation);
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity(81:100), true); % vectorized
            tableHandle.execute(tableOperation);
            
            % Fetch the elements from the first partition
            pk = 'pk1';
            
            % Setup the query
            qc = azure.storage.table.QueryComparisons.EQUAL;
            filterCondition = azure.storage.table.TableQuery.generateFilterCondition('PartitionKey',qc,pk);
            
            % Create a new table query;
            tableQuery = azure.storage.table.TableQuery;
            
            % Create the return type
            finalQuery = tableQuery.where(filterCondition);
            
            % Query the database
            queryResults = tableHandle.execute(finalQuery);
            
            % Assert the element that was fetched the one that was inserted
            testCase.verifyEqual(numel(queryResults), partitionSize);
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testDoubleDataType(testCase)
            disp('Running testDoubleDataType');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableDoubleDataType');
            % Create a table
            tableHandle.createIfNotExists();
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            testValue = rand(1);
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('DoubleValue');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.DoubleValue = testValue;
            dynamicEntity.initialize();
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
            
            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).DoubleValue;
            testCase.assertEqual(resultVal, testValue);
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testDoubleDataTypeVector(testCase)
            disp('Running testDoubleDataTypeVector');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableDoubleDataTypeVector');
            % Create a table
            tableHandle.createIfNotExists();
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            testValue = rand(1,10);
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('DoubleValueVector');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.DoubleValueVector = testValue;
            % verify this fails because trying to create a vector of non
            % uint8 or char
            testCase.verifyError(@()dynamicEntity.initialize(), 'Azure:WASB');
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testLogicalDataType(testCase)
            disp('Running testLogicalDataType');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableLogicalDataType');
            % Create a table
            tableHandle.createIfNotExists();
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % test with true
            testValue = true;
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('LogicalValue');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.LogicalValue = testValue;
            dynamicEntity.initialize();
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
            
            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).LogicalValue;
            testCase.assertEqual(resultVal, testValue);
            
            % test with false
            testValue = false;
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myLogicalValue');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myLogicalValue = testValue;
            dynamicEntity.initialize();
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
            
            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myLogicalValue;
            testCase.assertEqual(resultVal, testValue);
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testUUIDDataType(testCase)
            disp('Running testUUIDDataType');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableUUIDDataType');
            % Create a table
            tableHandle.createIfNotExists();
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % 16 byte value
            testValue = '0123456789ABCDEF';
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myUUID');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myUUID = testValue;
            dynamicEntity.initialize();
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
            
            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myUUID;
            testCase.assertEqual(resultVal, testValue);
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testDateTimeDataType(testCase)
            disp('Running testDateTimeDataType');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableDateTimeDataType');
            % Create a table
            tableHandle.createIfNotExists();
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a MATLAB datetime
            testValue = datetime;
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myDateTime');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myDateTime = testValue;
            dynamicEntity.initialize();
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
            
            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myDateTime;
            endTime = datetime;
            endTime.TimeZone = endTime.SystemTimeZone;
            % allow a 30s drift
            allowedTestDuration = duration('0:0:30');
            if endTime - resultVal < allowedTestDuration
                flag = true;
            else
                flag = false;
            end
            testCase.assertTrue(flag);
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testNullType(testCase)
            disp('Running testNullType');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableNullType');
            % Create a table
            tableHandle.createIfNotExists();
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue = [];
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myNull');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myNull = testValue;
            testCase.verifyError(@()dynamicEntity.initialize(), 'Azure:WASB');
            %             dynamicEntity.initialize();
            %
            %             % Create a table operation to execute on the database
            %             tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            %             tableHandle.execute(tableOperation);
            %
            %             % Retrieve a single entity
            %             % Create a dynamic resolver (return as Java HashMap)
            %             dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            %             tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            %             results = tableHandle.execute(tableOperation);
            %             % test that no property is set
            %             testCase.assertFalse(isprop(results,'myNull'));
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testInt64Type(testCase)
            disp('Running testInt64Type');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableInt64Type');
            % Create a table
            tableHandle.createIfNotExists();
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue = int64(99);
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myInt64');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myInt64 = testValue;
            dynamicEntity.initialize();
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
            
            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myInt64;
            testCase.assertTrue(isa(resultVal,'int64'));
            testCase.assertEqual(resultVal,int64(99));
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testInt32Type(testCase)
            disp('Running testInt32Type');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableInt32Type');
            % Create a table
            tableHandle.createIfNotExists();
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue = int32(99);
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myInt32');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myInt32 = testValue;
            dynamicEntity.initialize();
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
            
            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myInt32;
            testCase.assertTrue(isa(resultVal,'int32'));
            testCase.assertEqual(resultVal,int32(99));
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testInt16Type(testCase)
            disp('Running testInt16Type');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableInt16Type');
            % Create a table
            tableHandle.createIfNotExists();
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue = int16(99);
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myInt16');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myInt16 = testValue;
            dynamicEntity.initialize();
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
            
            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myInt16;
            testCase.assertTrue(isa(resultVal,'int32'));
            testCase.assertEqual(resultVal,int32(99));
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testBinaryType(testCase)
            disp('Running testBinaryType');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableBinaryType');
            % Create a table
            tableHandle.createIfNotExists();
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue = uint8('abcdefg');
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myBinary');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myBinary = testValue;
            dynamicEntity.initialize();
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
            
            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myBinary;
            testCase.assertTrue(isa(resultVal,'uint8'));
            testCase.assertEqual(char(resultVal),'abcdefg');
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testEmptyStr(testCase)
            disp('Running testEmptyStr');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableEmptyStr');
            % Create a table
            tableHandle.createIfNotExists();
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue = '';
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myEmptyStr');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myEmptyStr = testValue;
            dynamicEntity.initialize();
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
            
            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myEmptyStr;
            testCase.assertEmpty(resultVal);
            testCase.assertTrue(ischar(resultVal));
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testEmptyStrs(testCase)
            disp('Running testEmptyStrs');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableEmptyStrs');
            % Create a table
            tableHandle.createIfNotExists();
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue = ['','',''];
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myEmptyStrs');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myEmptyStrs = testValue;
            dynamicEntity.initialize();
            
            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
            
            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myEmptyStrs;
            testCase.assertEmpty(resultVal);
            testCase.assertTrue(ischar(resultVal));
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testDateTimeArray(testCase)
            disp('Running testDateTimeArray');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableDateTimeArray');
            % Create a table
            tableHandle.createIfNotExists();
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue1 = datetime;
            testValue2 = datetime;
            testValue = [testValue1, testValue2];
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myDatetimes');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myDatetimes = testValue;
            % TODO explain
            testCase.verifyError(@()dynamicEntity.initialize(), 'Azure:WASB');
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testStrArray(testCase)
            disp('Running testStrArray');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableStrArray');
            % Create a table
            tableHandle.createIfNotExists();
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);
            
            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue = ["ABC", "DE"];
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myStrArray');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myStrArray = testValue;
            % TODO explain
            testCase.verifyError(@()dynamicEntity.initialize(), 'Azure:WASB');
            
            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testNull(testCase)
            disp('Running testNull');
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            
            % create a client and a table
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBNullTest');
            tableHandle.createIfNotExists();
            
            % set intial partitionKey and rowKey
            pk = 'Smith';
            rk = 'John';
            
            % create first entry, no nulls
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.addprop('val1');
            dynamicEntity.addprop('val2');
            dynamicEntity.val1 = 'A';
            dynamicEntity.val2 = 'B';
            dynamicEntity.initialize();
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
            
            % create 2nd entry causing a null in val3 for 1st entry
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = 'Pat';
            dynamicEntity.addprop('val1');
            dynamicEntity.addprop('val2');
            dynamicEntity.addprop('val3');
            dynamicEntity.val1 = 'A';
            dynamicEntity.val2 = 'B';
            dynamicEntity.val3 = 'C';
            dynamicEntity.initialize();
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
            
            % create thrid entry with anumeric type and having nulls in the
            % val3 column
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = 'Joe';
            dynamicEntity.addprop('val1');
            dynamicEntity.addprop('val2');
            dynamicEntity.addprop('val4');
            dynamicEntity.val1 = 'A';
            dynamicEntity.val2 = 'B';
            dynamicEntity.val4 = 9;
            dynamicEntity.initialize();
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
            
            % create a datetime entry
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = 'Mary';
            dynamicEntity.addprop('val1');
            dynamicEntity.addprop('val2');
            dynamicEntity.addprop('val5');
            dynamicEntity.val1 = 'A';
            dynamicEntity.val2 = 'B';
            dynamicEntity.val5 = datetime('now', 'TimeZone', 'UTC');
            dynamicEntity.initialize();
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
            
            % Setup the query
            qc = azure.storage.table.QueryComparisons.EQUAL;
            filterCondition = azure.storage.table.TableQuery.generateFilterCondition('PartitionKey',qc,pk);
            % Create a new table query;
            tableQuery = azure.storage.table.TableQuery;
            % Create the return type
            finalQuery = tableQuery.where(filterCondition);
            % Query the database
            queryResults = tableHandle.execute(finalQuery);
            
            tableResult = table(queryResults);
            
            % Should look like:
            % tableResult =
            % 4×8 table
            % partitionKey    rowKey         timestamp          val1    val2    val3    val4             val5
            % ____________    ______    ____________________    ____    ____    ____    ____    ______________________
            %    'Smith'       'Joe'     09-Apr-2019 07:39:09    'A'     'B'     []      [9]     []
            %    'Smith'       'John'    08-Apr-2019 18:09:32    'A'     'B'     []      []      []
            %    'Smith'       'Mary'    09-Apr-2019 07:39:38    'A'     'B'     []      []      [09-Apr-2019 07:39:38]
            %    'Smith'       'Pat'     08-Apr-2019 18:09:40    'A'     'B'     'C'     []      []
            
            sz = size(tableResult);
            testCase.verifyEqual(sz(1,1), 4);
            testCase.verifyEqual(sz(1,2), 8);
            
            % for simpler comparisions
            logicalEmpty = logical([]);
            
            cellResult = tableResult{1,4};
            cellResult = cellResult{1};
            testCase.verifyEqual(cellResult, 'A');
            
            cellResult = tableResult{1,7};
            cellResult = cellResult{1};
            testCase.verifyEqual(cellResult, 9);
            
            cellResult = tableResult{1,6};
            cellResult = cellResult{1};
            testCase.verifyEqual(cellResult, logicalEmpty);
            
            cellResult = tableResult{3,6};
            cellResult = cellResult{1};
            testCase.verifyEqual(cellResult, logicalEmpty);
            
            cellResult = tableResult{3,8};
            cellResult = cellResult{1};
            tNow = datetime('now', 'TimeZone', 'UTC');
            deltaT = tNow - cellResult;
            testCase.verifyLessThan(deltaT, minutes(1));
            
            % cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testEmptyResult(testCase)
            disp('Running testEmptyResult');
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            
            % create a client and a table
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBEmptyResultTest');
            tableHandle.createIfNotExists();
            
            % set intial partitionKey and rowKey
            pk = 'Smith';
            rk = 'John';
            
            % create first entry, no nulls
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.addprop('val1');
            dynamicEntity.addprop('val2');
            dynamicEntity.val1 = 'A';
            dynamicEntity.val2 = 'B';
            dynamicEntity.initialize();
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
            
            % Setup a query that returns results
            qc = azure.storage.table.QueryComparisons.EQUAL;
            filterCondition = azure.storage.table.TableQuery.generateFilterCondition('PartitionKey',qc,pk);
            % Create a new table query;
            tableQuery = azure.storage.table.TableQuery;
            % Create the return type
            finalQuery = tableQuery.where(filterCondition);
            % Query the database
            queryResults = tableHandle.execute(finalQuery);
            tableResult = table(queryResults);
            
            % Validate results returned
            sz = size(tableResult);
            testCase.verifyEqual(sz(1,1), 1);
            testCase.verifyEqual(sz(1,2), 5);
            cellResult = tableResult{1,4};
            testCase.verifyEqual(cellResult, 'A');
            
            % Setup a query that returns no results because the
            % partitionKey is not present, check that an empty table is
            % returned
            qc = azure.storage.table.QueryComparisons.EQUAL;
            filterCondition = azure.storage.table.TableQuery.generateFilterCondition('PartitionKey',qc,'myInvalidPK');
            % Create a new table query;
            tableQuery = azure.storage.table.TableQuery;
            % Create the return type
            finalQuery = tableQuery.where(filterCondition);
            % Query the database
            queryResults = tableHandle.execute(finalQuery);
            tableResult = table(queryResults);
            testCase.verifyEmpty(tableResult);
            
            % cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            client.delete();
        end
        
        function testWaitAMinute(testCase) %#ok<MANU>
            disp('Running testWaitAMinute');
            % wait to allow time for all the previous delete operations to
            % complete before the test might run again
            % TODO consider adding UID to table names
            pause(60);
        end
        
    end % methods  
    
end % class
