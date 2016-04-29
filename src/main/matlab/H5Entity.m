classdef H5Entity < handle
    
    properties(Abstract)
        identifier
        group
    end
    
    properties(SetAccess = protected)
        queryPath
    end
    
    methods
        
        function sz = getH5Size(obj, schema)

            fields = fields(schema);
            n = numel(fields)
            sz = ones(1, n);
            
            for i = 1 : n
                h5DataType = schema.(fields{i});

                switch h5DataType
                    
                    case H5DataType.DOUBLE_GROUP
                        doubleType = H5T.copy('H5T_NATIVE_DOUBLE');
                        sz(i)= H5T.get_size(doubleType);
                    
                    case H5DataType.INTEGER_GROUP
                        intType = H5T.copy('H5T_NATIVE_INT');
                        sz(i)= H5T.get_size(intType);
                end
            end
        end

        function createSchema(obj)

            schema = obj.schema;
            sz = obj.getH5Size(schema);
            offset(1) = 0;
            offset(2 : n) = cumsum(sz(1 : n-1));
            filetype = H5T.create ('H5T_COMPOUND', sum(sz));
            
            for i = 1 : n
                h5DataType = schema.(fields{i});
                H5T.insert(filetype, fields{i}, offset(i), h5DataType.type);
            end
        end

        function prepareQuery(obj, queryPathHandle)
            obj.queryPath = @(fname) strcat(obj.group.toPath(), queryPathHandle(fname));
        end
        
        function n = getTableSize(~, data)
            names = fieldnames(data);
            n = numel(data.(names{1}));
        end
    end
    
    methods(Abstract)
        getPersistanceData(obj)
        setQueryResponse(obj, rdata, n)
    end
end
