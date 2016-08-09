classdef ElementCollection < handle
    
    properties(Access = private)
        jElementCollection
    end
    
    properties(Dependent)
        name
        attributeType
    end
    
    methods
        
        function obj = ElementCollection(jElementCollection)
            obj.jElementCollection = jElementCollection;
        end
        
        function name = get.name(obj)
            name = char(obj.jElementCollection.getName());
        end
        
        function type = get.attributeType(obj)
            type = char(obj.jElementCollection.getAttributeType());
        end
    end
end

