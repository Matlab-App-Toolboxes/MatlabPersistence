classdef CompoundEntityAttr < io.mpa.H5Entity
    
   properties
		integers 
		doubles  
		strings
		id  
        identifier
	end

	properties
		group
		finalSchema 
	end

	methods
        
        function obj = CompoundEntityAttr(id)
            obj.identifier = id;
        end
        
        function group = get.group(obj)
             group = [TestPersistence.COMPUND_ENTITY_ATTR.toPath() date];
        end
        
        function s = get.finalSchema(obj)
            s = TestPersistence.COMPUND_ENTITY_ATTR.schema;
        end
    end
end