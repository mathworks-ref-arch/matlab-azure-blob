classdef TableResult < azure.object
    % TABLERESULT provides an abstraction over the Azure Table Result
    % EdmTypes are mapped to and from MATLAB data types as follows:
    %   Edm.Boolean    - logical
    %   Edm.Binary     - uint8
    %   Edm.DateTime   - datetime
    %   Edm.Double     - double
    %   Edm.Guid       - char vector (16 bytes)
    %   Edm.Int16      - int32
    %   Edm.Int32      - int32
    %   Edm.Int64      - int64
    %   Null           - logical (empty)
    %   Edm.String     - char vector
    %
    % Other Edm types e.g. Edm.Decimal are not currently support by the
    % underlying Azure Java libraries.
    %
    % A null entity should not be returned as Azure Table does not persist them.
    % If a null entity value is returned an empty array of the corresponding
    % type is returned. In the case of a datetime a NaT is returned.
    % Null entities cannot be created using this interface however empty
    % string and character values can be used.
    %
    % The following Microsoft comment describes this further:
    %  "The Table service does not persist null values for properties. When
    %   querying entities, the above property types are all non-nullable. When
    %   writing entities, the above property types are all nullable, and any
    %   property with a null value is handled as if the payload did not contain
    %   that property."
    %
    % For further information see:
    % https://docs.microsoft.com/en-us/rest/api/storageservices/Understanding-the-Table-Service-Data-Model
    %
    % A char array will be stored in concatenated form and returend as a
    % char vector.
    % string arrays are not supported by the Azure Table API.
    % datetime values must be scalar and not empty.

    % Copyright 2018 The MathWorks, Inc.

    properties
    end

    methods
        %% Constructor
        function obj = TableResult(varargin)
            if nargin==1
                % Store the handle to the java object
                obj.Handle=varargin{1};

                % Initialize the object
                obj.initialize();
            end
        end

        function initialize(obj,varargin)

            % Locate the names of the properties and add them
            jHandle = obj.Handle;

            switch class(jHandle)
                case 'com.microsoft.azure.storage.table.DynamicTableEntity'
                    % TODO - this is just an echo of the inserted objects
                    % will handle this case later.
                case 'java.util.HashMap'
                    % Result array from the HashMapResolver
                    keys = jHandle.keySet();
                    values = jHandle.values();
                    kIter = keys.iterator();
                    vIter = values.iterator();

                    % For each key, update the dynamic object
                    while kIter.hasNext()
                        keyName = char(kIter.next());
                        obj.addprop(keyName);
                        obj.(keyName)=azure.storage.table.TableResult.getTypedResult(vIter.next());
                    end
                otherwise
                    % Edge cases
                    logObj = Logger.getLogger();
                    write(logObj,'error',['Unsupported type: ', class(jHandle)]);
            end
        end
    end


    methods(Static)
        function val = getTypedResult(entity)
            % Map the supported subset of Edm types to MATLAB Types
            % Please see:
            % https://azure.github.io/azure-sdk-for-java/com/microsoft/azure/storage/table/EdmType.html
            % https://docs.microsoft.com/en-us/rest/api/storageservices/Understanding-the-Table-Service-Data-Model
            val = logical([]); % defensively

            % Big switch yard since Java and #NET are strongly typed
            switch char(entity.getEdmType)
                % entity methods support a getValueAsBoolean & getValueAsBooleanObject
                % in both cases the EdmType will be Boolean however the BooleanObject
                % is a Java Boolean not a boolean and so can be null, the getIsNull
                % tests this an if it is a null returns an empty MATLAB logical array
                % as a MATLAB logical cannot be null (as per a Java boolean)
                % A similar problem arises for other datatypes
                % Note these values could be populated by clients other than MATLAB
                case 'Edm.Boolean'
                    if entity.getIsNull()
                        val = logical([]);
                    else
                        val = logical(entity.getValueAsBoolean());
                    end

                case {'Edm.Binary'}
                    if entity.getIsNull()
                        val = uint8([]);
                    else
                        % note required transpose of return value
                        val = uint8(entity.getValueAsByteArray())';
                    end

                case 'Edm.DateTime'
                    if entity.getIsNull()
                        % return NaT rather than empty
                        val = NaT();
                    else
                        dateJ = entity.getValueAsDate();
                        val = datetime(dateJ.getTime()/1000,'convertfrom','posixtime','TimeZone','UTC');
                    end

                case 'Edm.Double'
                    if entity.getIsNull()
                        val = double([]);
                    else
                        val = double(entity.getValueAsDouble());
                    end

                case 'Edm.Guid'
                    % Represents a 16-byte (128-bit) unique identifier value
                    uuidJ = entity.getValueAsUUID();
                    val = char(uuidJ.toString());

                case {'Edm.Int16', 'Edm.Int32'}
                    if entity.getIsNull()
                        val = int32([]);
                    else
                        % entity methods can only return one type of non-long integer
                        val = int32(entity.getValueAsInteger());
                    end

                case 'Edm.Int64'
                    if entity.getIsNull()
                        val = int64([]);
                    else
                        val = int64(entity.getValueAsLong());
                    end

                case 'Null'
                    val = logical([]);

                case 'Edm.String'
                    if entity.getIsNull()
                        val = '';
                    else
                        val = char(entity.getValueAsString());
                    end

                case {'Edm.DateTimeOffset', 'Edm.Decimal', 'Edm.Time', 'Edm.SByte','Edm.Single','Edm.Byte'}
                    % not a complete list but most likely errors, as they are
                    % defined in the Azure enum EdmType
                    % custom deserialisation methods should be straightforward
                    % but are not implemented as types are not supported by entities
                    logObj = Logger.getLogger();
                    write(logObj,'error',['Type not supported by com.microsoft.azure.storage.table.EntityProperty.getValueAs<Type> method: ', char(entity.getEdmType)]);

                otherwise
                    logObj = Logger.getLogger();
                    write(logObj,'error',['Unsupported type: ', class(jHandle)]);
            end
        end
    end
end %class
