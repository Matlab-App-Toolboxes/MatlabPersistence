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
        
        function setQueryResponse(obj, rdata, dims)
            obj.integer = int32(rdata.integer);
            obj.double = rdata.double;
            obj.string = rdata.string;
        end
        
        function group = get.group(obj)
            group = [TestPersistence.SIMPLE_ENTITY_ATTR.toPath() date];
        end
        
        function s = get.finalSchema(obj)
            s = TestPersistence.SIMPLE_ENTITY_ATTR.schema;
        end
    end
end