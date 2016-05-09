classdef ComplexEntity < io.mpa.H5Entity
    
    properties
        integer
        double
        string
        
        integersDs
        doublesDs
        stringsDs
        
        integersAttr
        doublesAttr
        stringsAttr

        identifier
    end
    
    properties
        group
        entityId = TestPersistence.COMPLEX_ENTITY
    end

    methods
        
        function obj = ComplexEntity(id)
            obj.identifier = id;
        end
        
        function group = get.group(obj)
            group = [obj.entityId.toPath() date];
        end
    end
end