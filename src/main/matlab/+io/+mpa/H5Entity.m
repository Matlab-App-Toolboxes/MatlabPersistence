classdef H5Entity < handle
    
    properties(Abstract)
        entityId
        group
    end
    
    properties
        isGroupCreated = false;
        isIdentifierCreated = false;
        finalSchema
        identifier
    end
    
    methods
        
        function obj = H5Entity(identifier)
            obj.identifier = identifier;
        end
        
        function s = getSchema(obj, targetH5DataClass)
            import io.mpa.*;
            s = obj.finalSchema;
            props = fieldnames(s);
            
            isH5DataClassEq = @(str)(isequal(H5DataType.(str).class, targetH5DataClass));
            indices = cellfun(@(p) isH5DataClassEq(s.(p)), props);
            
            s = rmfield(s, props(~indices));
            
            if isempty(fieldnames(s))
                s= [];
            end
        end
        
        function [data, size] = toStructure(obj, schema)
            props = fieldnames(schema);
            
            for i = 1:numel(props)
                data.(props{i}) = obj.(props{i});
            end
            size = length(obj.(props{1}));
        end
        
        function setQueryResponse(obj, rdata, schema)
            props = fields(schema);
            for i = 1:numel(props)
                obj.(props{i}) = rdata.(props{i});
            end
        end
        
        function s = get.finalSchema(obj)
            s = obj.finalSchema;
        end
        
        function prePersist(obj)
            obj.finalSchema = obj.entityId.schema;
        end
        
        function preFind(obj)
            obj.finalSchema = obj.entityId.schema;
        end
        
        function postPersist(obj)
        end
        
        function postFind(obj)
        end
    end
end
