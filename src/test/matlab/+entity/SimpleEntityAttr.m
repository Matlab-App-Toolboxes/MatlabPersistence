classdef SimpleEntityAttr < io.mpa.H5Entity
    
    properties
        integer
        double
        string
        id
        identifier
    end
    
    properties
        group
        entityId = TestPersistence.SIMPLE_ENTITY_ATTR
    end
    
    methods
        
        function obj = SimpleEntityAttr(id)
            obj.identifier = id;
        end
        
        function group = get.group(obj)
            group = [obj.entityId.toPath() date];
        end
    end
end