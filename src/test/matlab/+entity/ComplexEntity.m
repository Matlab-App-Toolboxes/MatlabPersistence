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
        
        function setQueryResponse(obj, rdata, dims)
            obj.integer = int32(rdata.integer);
            obj.double = rdata.double;
            obj.string = rdata.string;
            
            obj.integersDs = int32(rdata.integer(:));
            obj.doublesDs = rdata.double(:);
            obj.stringsDs = rdata.string(:);
            
            obj.integersAttr = int32(rdata.integer(:));
            obj.doublesAttr = rdata.double(:);
            obj.stringsAttr = rdata.string(:);
        end
        
        function group = get.group(obj)
            group = [TestPersistence.COMPLEX_ENTITY.toPath() date];
        end
        
        function s = get.finalSchema(obj)
            s = TestPersistence.COMPLEX_ENTITY.schema;
        end
    end
end