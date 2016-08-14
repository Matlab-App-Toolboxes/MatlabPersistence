classdef EntityManager < handle
    
    properties(Access = private)
        path
    end
    
    properties(Access = private)
        tableCache
        rowCache
        fname
    end
    
    properties
        closeInitializer
    end
    
    methods
        
        function obj = EntityManager(path)
            obj.path = path;
        end
        
        function load(obj, entity)
            
            clazz = mpa.util.getClazz(entity);
            if ~ isempty(obj.tableCache)
                return
            end
            name = matlab.lang.makeValidName(clazz);
            obj.fname = [obj.path name '.mat'];
            
            result = load(obj.fname);
            obj.tableCache = result.table;
            obj.rowCache = cell(0, numel(result.table.Properties.VariableNames));
        end
        
        function entity = find(obj, entity)
            obj.load(entity);
            
            if isempty(entity.id)
                id = max(obj.tableCache.id);
            end
            
            columns = obj.tableCache.Properties.VariableNames;
            row = obj.tableCache.id == id;
            result = obj.tableCache(row, columns);
            
            for i = 1 : numel(columns)
                property = columns{i};
                entity.(property) = result.(property);
            end
        end
        
        function entity = persist(obj, entity)
            obj.load(entity);
            
            counter = 0;
            if ~ isempty(obj.tableCache)
                counter = max(obj.tableCache.id);
            end
            
            if isempty(entity.id)
                entity.id  = counter + 1;
            end
            columns = obj.tableCache.Properties.VariableNames;
            
            for i = 1 : numel(columns)
                column = columns{i};
                obj.rowCache{entity.id, i} = entity.(column);
            end
            newTable = cell2table(obj.rowCache, 'VariableNames', columns);
            obj.tableCache = [obj.tableCache; newTable];
        end
        
        function close(obj)
            table = obj.tableCache;
            save(obj.fname, 'table');
            obj.rowCache = [];
            obj.tableCache = [];
            obj.fname = [];
            obj.closeInitializer();
        end
        
        function delete(obj)
            obj.closeInitializer();
        end
        
    end
end

