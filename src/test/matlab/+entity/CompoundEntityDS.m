classdef CompoundEntityDS < io.mpa.H5Entity
    
    properties
        integers
        doubles
        strings
        
        identifier
    end
    
    properties
        group
        entityId = TestPersistence.COMPUND_ENTITY_DS
    end
    
    methods
        
        function obj = CompoundEntityDS(id)
            obj.identifier = id;
        end
        
        function group = get.group(obj)
            group = [obj.entityId.toPath() date];
        end
    end
end