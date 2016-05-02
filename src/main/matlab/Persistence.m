classdef Persistence
    
    enumeration
    end
    
    methods
        function path = toPath(obj)
            path = ['/' char(obj) '/'];
        end
    end
end

