classdef TableManager < handle
    
    properties(Access = private)
        path
    end
    
    properties(Access = private)
        tableCache
        fname
    end
    
    properties
        closeInitializer
    end
    
    methods
        
        function obj = TableManager(path)
            obj.path = path;
        end
        
        function load(obj, entity)
            clazz = entity;
            
            if ~ ischar(entity)
                clazz = mpa.util.getClazz(entity);
            end
            
            if ~ isempty(obj.tableCache)
                return
            end
            name = matlab.lang.makeValidName(clazz);
            obj.fname = [obj.path name '.mat'];
            
            result = load(obj.fname);
            obj.tableCache = result.table;
        end
        
        function entity = find(obj, entity)
            obj.load(entity);
            columns = obj.tableCache.Properties.VariableNames;
            idColumn = columns{1};
            
            if isempty(entity.(idColumn))
                id = max(obj.tableCache.id);
            end
            
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
            columns = obj.tableCache.Properties.VariableNames;
            
            idColumn = columns{1};
            
            if isempty(entity.(idColumn))
                entity.(idColumn)  = counter + 1;
            end
            rowCache = cell(0, numel(columns));
            
            for i = 1 : numel(columns)
                column = columns{i};
                rowCache{i} = entity.(column);
            end
            newTable = cell2table(rowCache, 'VariableNames', columns);
            obj.tableCache = [obj.tableCache; newTable];
            
            table = obj.tableCache;
            save(obj.fname, 'table');
        end
        
        function query = createQuery(obj, clazz)
            obj.load(clazz);
            query = linq(table2struct(obj.tableCache));
        end
        
        function close(obj)
            obj.tableCache = [];
            obj.fname = [];
            obj.closeInitializer();
        end
        
        
        function delete(obj)
            obj.closeInitializer();
        end
        
    end
end

