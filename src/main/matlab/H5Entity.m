classdef H5Entity < handle
    
    properties(Abstract)
        identifier
        group
    end
    
    properties(SetAccess = private)
        queryPath
    end
    
    methods
        
        function prepareQuery(obj, queryPathHandle)
            obj.queryPath = @(fname) strcat(obj.group.toPath(), queryPathHandle(fname));
        end
        
        function n = getTableSize(~, data)
            names = fieldnames(data);
            n = numel(data.(names{1}));
        end
    end
    
    methods(Abstract)
        createSchema(obj)
        getPersistanceData(obj);
        setQueryResponse(obj, rdata, n)
    end
end
