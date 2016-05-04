classdef H5Entity < handle
    
    properties(Abstract)
        identifier
        group
        finalSchema
    end
    
    properties
        isGroupCreated = false;
        isIdentifierCreated = false;
    end
    
    methods
        
        function s = getSchema(obj, targetH5DataClass)
            import io.mpa.*;
            s = obj.finalSchema;
            props = fields(s);
            
            isH5DataClassEq = @(str)(isequal(H5DataType.(str).class, targetH5DataClass));
            indices = cellfun(@(p) isH5DataClassEq(s.(p)), props);
            
            s = rmfield(s, props(~indices));
        end
        
        function [data, size] = toStructure(obj, schema)
    
            props = fields(schema);

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
    end
end
