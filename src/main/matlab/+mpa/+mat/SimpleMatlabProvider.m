classdef SimpleMatlabProvider < mpa.core.AbstractProvider
    
    properties
        manager
        entityMap
    end
    
    methods
        
        function createDefintion(obj)
            if ~ exist(obj.localPath, 'file')
                mkdir(obj.localPath);
            end
        end
        
        function createEntites(obj, entityMap)
            entities = entityMap.keys();
            
            for i = 1 : numel(entities)
                e = entities{i};
                schema = entityMap(e);
                obj.createTable(schema);
            end
            obj.entityMap = entityMap;
        end
        
        function createTable(obj, schema)
            name = matlab.lang.makeValidName(schema.class);
            fname = [obj.localPath name '.mat'];
            
            if exist(fname, 'file')
                return;
            end
            variables = {schema.id.name , schema.basics(:).name schema.elementCollections(:).name};
            data = cell(0, numel(variables));
            table = cell2table(data);
            table.Properties.VariableNames = variables;
            save(fname, 'table');
        end
        
        function manager = createEntityManager(obj)
            
            if ~ exist(obj.localPath, 'file')
                error('Matlab:persistence:filenotfound', 'h5 file not found');
            end
            if isempty(obj.manager)
                manager = mpa.mat.TableManager(obj.localPath);
            end
            obj.manager = manager;
        end
        
        function close(obj)
            % TODO synchronize with server
            obj.manager.close();
            delete(obj.manager);
            obj.manager = [];
        end
    end
    
end

