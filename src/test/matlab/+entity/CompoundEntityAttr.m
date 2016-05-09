classdef CompoundEntityAttr < io.mpa.H5Entity
    
   properties
		integers 
		doubles  
		strings
		  
        identifier
	end

	properties
		group
        entityId = TestPersistence.COMPUND_ENTITY_ATTR
	end

	methods
        
        function obj = CompoundEntityAttr(id)
            obj.identifier = id;
        end
        
        function group = get.group(obj)
            group = [obj.entityId.toPath() date];
        end
    end
end