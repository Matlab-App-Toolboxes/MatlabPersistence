classdef SimpleEntityAttr < io.mpa.H5Entity
    
    properties
        integer
        double
        string
    end
    
    properties
        group
        entityId = TestPersistence.SIMPLE_ENTITY_ATTR
    end
    
    methods
        
        function obj = SimpleEntityAttr(id)
            obj = obj@io.mpa.H5Entity(id);
        end
        
        function group = get.group(obj)
            group = [obj.entityId.toPath() date];
        end
        
        function queryHandle = getAllKeys(obj)
            queryHandle = @(name) resultSet(h5info(name, obj.entityId.toPath()));
            
            function result = resultSet(info)
                result = arrayfun(@(g) g.name, info.Groups);
            end
        end
    end
end