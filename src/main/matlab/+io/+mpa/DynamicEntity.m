classdef DynamicEntity < handle
    
    properties(SetObservable)
        dynamicSchema
    end
    
    properties(Abstract)
        prefix
        extendedStruct
    end
    
    properties
        structureFields
    end
    
    methods
        
        function obj = DynamicEntity()
            addlistener(obj, 'dynamicSchema', 'PostSet', @obj.updateFinalSchema);
        end
        
        function data = mergeStructure(obj, data)
            structFields = fieldnames(obj.extendedStruct);
            
            for i = 1 : numel(structFields)
                prop = obj.structureFields{i};
                data.(prop) = obj.extendedStruct.(structFields{i});
            end
        end
        
        function mergeProperties(obj, rdata)
            start = length(obj.prefix) + 2;
            
            for i = 1 : numel(obj.structureFields)
                prop = obj.structureFields{i};
                obj.extendedStruct.(prop(start : end)) = rdata.(prop);
            end
        end
        
        function setDynamicSchema(obj, schema, structure)
            dataType = schema.(obj.prefix);
            fields = fieldnames(structure);
            
            schema = rmfield(schema, obj.prefix);
            for i = 1 : numel(fields)
                prop = [obj.prefix '_' fields{i}];
                schema.(prop) = dataType;
            end
            obj.dynamicSchema = savejson(schema);
        end
        
        function setStructureFields(obj, schema)
            fields = fieldnames(schema);
            position = ~ cellfun(@isempty, strfind(fields, obj.prefix));
            obj.structureFields = fields(position);
        end
        
        function tf = isSchemaDynamic(obj, schema)
            tf = ~ isempty(obj.structureFields) && sum(ismember(obj.structureFields, fieldnames(schema))) > 0;
        end
    end
    
    methods(Abstract)
        updateFinalSchema(obj, src, event);
    end
end

