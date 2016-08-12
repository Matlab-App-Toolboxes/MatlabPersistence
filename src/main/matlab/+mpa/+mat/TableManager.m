classdef TableManager < handle
    
    properties
        path
        types
    end
    
    properties(Access = private)
        tableCache
    end
    
    properties(Transient)
        currentTypes
    end
    
    methods
        
        function obj = TableManager(path)
            obj.path = path;
            result = load(obj.path);
            obj.tableCache = result.table;
        end
        
        function entity = find(obj, entity)
            id = entity.id;
            
            if isempty(id)
                id = max(obj.tableCache.id);
            end
            
            row = obj.tableCache.id == id;
            result = obj.tableCache{row, obj.currentTypes};
            
            for i = 1 : numel(obj.currentTypes)
                type = obj.currentTypes(i);
                entity.(type) = result(i);
            end
        end
        
        function entity = save(obj, entity)
            
            if isempty(entity.id)
                entity.id  = max(obj.tableCache.id) + 1;
            end
            
            for i = 1 : numel(obj.currentTypes)
                type = obj.currentTypes(i);
                obj.tableCache{row, type} = entity.(type);
            end
        end
        
        function close(obj)
            % Do nothing
        end
        
        function saveTable(obj)
            table = obj.tableCache;
            save(obj.path, 'table');
        end
    end
    
    methods(Static)
        
        function createTable(path, schema)
            data = cell(0, numel(schema));
            table = cell2table(data);
            table.Properties.VariableNames = schema;
            save(path, 'table');
        end
    end
    
end

