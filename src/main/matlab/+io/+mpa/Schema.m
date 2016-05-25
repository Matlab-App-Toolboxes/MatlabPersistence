classdef (Abstract)Schema< handle
    
    properties
        schema
    end
    
    methods
        
        function obj = Schema(str)
            obj.schema = loadjson(['{' str(1 : end -1) '}']);
        end
        
        function path = toPath(obj)
            path = ['/' char(obj) '/'];
        end
    end
end

