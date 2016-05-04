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
        finalSchema
    end
    
    methods
        
        function obj = SimpleEntityAttr(id)
            obj.identifier = id;
        end
        
        function group = get.group(obj)
            group = [TestPersistence.SIMPLE_ENTITY_ATTR.toPath() date];
        end
        
        function s = get.finalSchema(obj)
            s = TestPersistence.SIMPLE_ENTITY_ATTR.schema;
        end
    end
end