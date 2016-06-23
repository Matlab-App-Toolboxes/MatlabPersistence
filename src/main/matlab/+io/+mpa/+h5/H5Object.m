classdef H5Object < handle
    
    properties
        types
        fname
        mapper
    end
    
    properties(Abstract)
        memType
        space
    end
    
    methods
        
        function clear(obj)
            obj.types = [];
            obj.mapper = [];
        end
    end
    
end

