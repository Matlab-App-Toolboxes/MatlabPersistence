classdef (Abstract)Persistence< handle
    
    properties
        schema
    end
    
    methods
        
        function obj = Persistence(str)
            obj.schema = loadjson(['{' str(1 : end -1) '}']);
        end
        
        function path = toPath(obj)
            path = ['/' char(obj) '/'];
        end
    end
end

