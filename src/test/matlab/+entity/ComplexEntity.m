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
        
        extendedStruct
    end
    
    properties(SetObservable)
        dynamicSchema
    end
    
    properties
        group
        entityId = TestPersistence.COMPLEX_ENTITY
    end
    
    properties(Constant)
        KEY_STRING_PREFIX = 'struct'
    end
    
    methods
        
        function obj = ComplexEntity(id)
            obj = obj@io.mpa.H5Entity(id);
            addlistener(obj, 'dynamicSchema', 'PostSet', @obj.updateFinalSchema);
            obj.isDynamicSchema = true;
        end
        
        function group = get.group(obj)
            group = [obj.entityId.toPath() date];
        end
        
        function updateFinalSchema(obj, ~ , ~)
            json = loadjson(obj.dynamicSchema);
            obj.finalSchema = json.schema;
        end
        
        function prePersist(obj)
            
            schema = obj.entityId.schema;
            dataType = schema.(obj.KEY_STRING_PREFIX);
            schema = rmfield(schema, obj.KEY_STRING_PREFIX);
            fields = fieldnames(obj.extendedStruct);
            
            for i = 1 : numel(fields)
                prop = [obj.KEY_STRING_PREFIX '_' fields{i}];
                schema.(prop) = dataType;
            end
            obj.dynamicSchema = savejson(schema);
        end
        
        function [data, size] = toStructure(obj, schema)
            structFields = fieldnames(obj.extendedStruct);
            expectedSchemaFields = cellfun(@(s) strcat(obj.KEY_STRING_PREFIX, '_' ,s) , structFields, 'UniformOutput', false);
            
            if  ~ sum(ismember(expectedSchemaFields, fieldnames(schema)))
                [data, size] = toStructure@io.mpa.H5Entity(obj, schema);
                return
            end
            
            [data, size] = toStructure@io.mpa.H5Entity(obj, rmfield(schema, expectedSchemaFields));
            
            for i = 1 : numel(structFields)
                prop = expectedSchemaFields{i};
                data.(prop) = obj.extendedStruct.(structFields{i});
            end
        end
        
        function setQueryResponse(obj, rdata, schema)           
            fields = fieldnames(schema);
            position = ~ cellfun(@isempty, strfind(fields, obj.KEY_STRING_PREFIX));
            
            if sum(position) == 0
                setQueryResponse@io.mpa.H5Entity(obj, rdata, schema);
                return;
            end
            structFields = fields(position);
            setQueryResponse@io.mpa.H5Entity(obj, rdata,  rmfield(schema, structFields));
            
            start = length(obj.KEY_STRING_PREFIX) + 2;
            for i = 1 : numel(structFields)
                prop = structFields{i};
                obj.extendedStruct.(prop(start : end)) = rdata.(prop);
            end
        end
    end
end