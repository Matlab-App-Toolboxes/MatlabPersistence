classdef HelloWorld < handle
    
    properties(SetAccess = private)
        resourceProperties
    end
    
    methods
        
        function obj = HelloWorld()
            cp = getClassPath();
            res = [cp.resources 'properties.json'];
            json = loadjson(res);
            obj.resourceProperties = json.props;
        end
    end
end

