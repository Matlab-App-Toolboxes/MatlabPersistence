classdef SimpleEntityAttr < io.mpa.H5Entity
    
    properties
        integer
        double
        string
        dateString
    end
    
    properties
        group
        entityId = TestSchema.SIMPLE_ENTITY_ATTR
    end
    
    methods
        
        function obj = SimpleEntityAttr(id)
            obj = obj@io.mpa.H5Entity(id);
        end
        
        function group = get.group(obj)
            if isempty(obj.dateString)
                obj.dateString = char(date);
            end
            group = [obj.entityId.toPath() obj.dateString];
        end
        
        function queryHandle = getAllKeys(obj)
            queryHandle = @(name) resultSet(h5info(name, obj.entityId.toPath()));
            start = length(obj.entityId.toPath()) + 1;
            
            function result = resultSet(info)
                result = arrayfun(@(g) g.Name(start : end), info.Groups, 'UniformOutput', false);
            end
        end
    end
end