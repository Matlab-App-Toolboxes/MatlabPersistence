classdef CompoundEntityDS < io.mpa.H5Entity
    
    properties
        integers
        doubles
        strings
    end
    
    properties
        group
        entityId = TestSchema.COMPUND_ENTITY_DS
    end
    
    methods
        
        function obj = CompoundEntityDS(id)
            obj = obj@io.mpa.H5Entity(id);
        end
        
        function group = get.group(obj)
            group = [obj.entityId.toPath() date];
        end
    end
end