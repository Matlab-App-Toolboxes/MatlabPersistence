classdef SimpleMatlabProvider < mpa.core.AbstractProvider
    
    properties
        manager
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
                table = matlab.lang.makeValidName(e);
                
                schema = entityMap(e);
                TableManager.createTable([obj.path filesep table '.mat'], schema);
            end
        end
        
        function m = getManager(obj, types)
            
            if ~ exist(obj.localPath, 'file')
                error('Matlab:persistence:filenotfound', 'h5 file not found');
            end
            if isemty(obj.manager)
                obj.manager = mpa.mat.TableManager(obj.localPath);
            end
            obj.manager.currentTypes = types;
            m = obj.manager;
        end
        
        function close(obj)
            obj.manager.saveTable();
            delete(obj.manager);
        end
    end
    
end

