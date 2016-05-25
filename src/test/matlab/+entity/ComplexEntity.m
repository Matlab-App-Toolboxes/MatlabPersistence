classdef ComplexEntity < io.mpa.H5Entity & io.mpa.DynamicEntity
    
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
    end
    
    properties
        group
        entityId = TestSchema.COMPLEX_ENTITY
        prefix = 'struct'
        extendedStruct
    end
    
    methods
        
        function obj = ComplexEntity(id)
            obj = obj@io.mpa.DynamicEntity();
            obj = obj@io.mpa.H5Entity(id);
        end
        
        function group = get.group(obj)
            group = [obj.entityId.toPath() date];
        end
        
        function updateFinalSchema(obj, ~ , ~)
            json = loadjson(obj.dynamicSchema);
            obj.finalSchema = json.schema;
            obj.setStructureFields(obj.finalSchema)
        end
        
        function prePersist(obj)
            obj.setDynamicSchema(obj.entityId.schema, obj.extendedStruct);
        end
        
        function [data, size] = toStructure(obj, schema)
            
            if ~ obj.isSchemaDynamic(schema)
                [data, size] = toStructure@io.mpa.H5Entity(obj, schema);
                return;
            end
            [data, size] = toStructure@io.mpa.H5Entity(obj, rmfield(schema, obj.structureFields));
            data = obj.mergeStructure(data);
        end
        
        function setQueryResponse(obj, rdata, schema)
            
            if ~ obj.isSchemaDynamic(schema)
                setQueryResponse@io.mpa.H5Entity(obj, rdata, schema);
                return;
            end
            
            setQueryResponse@io.mpa.H5Entity(obj, rdata, rmfield(schema, obj.structureFields));
            obj.mergeProperties(rdata);
        end
    end
end