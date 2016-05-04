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
        
        id
        identifier
    end
    
    properties
        group
        finalSchema
    end

    methods
        
        function obj = ComplexEntity(id)
            obj.identifier = id;
        end
        
        function group = get.group(obj)
            group = [TestPersistence.COMPLEX_ENTITY.toPath() date];
        end
        
        function s = get.finalSchema(obj)
            s = TestPersistence.COMPLEX_ENTITY.schema;
        end
    end
end