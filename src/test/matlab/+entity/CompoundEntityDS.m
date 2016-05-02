classdef CompoundEntityDS < io.mpa.H5Entity
    
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
        
        function obj = CompoundEntityDS(id)
            obj.identifier = id;
        end
        
        function setQueryResponse(obj, rdata, dims)
            obj.integers = int32(rdata.integers(:));
            obj.doubles = rdata.doubles(:);
            obj.strings = rdata.strings(:);
        end
        
        function group = get.group(obj)
            group = [TestPersistence.COMPUND_ENTITY_DS.toPath() date];
        end
        
        function s = get.finalSchema(obj)
            s = TestPersistence.COMPUND_ENTITY_DS.schema;
        end
    end
end