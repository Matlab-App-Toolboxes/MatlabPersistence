classdef Basic < handle
    
    properties(Access = private)
        jBasic
    end
    
    properties(Dependent)
        name
        attributeType
    end
    
    properties(SetAccess = private)
        converter
    end
    
    methods
        
        function obj = Basic(jBasic)
            obj.jBasic = jBasic;
            converterClazz = obj.jBasic.getConverter().getClazz();
            
            if ~ isempty(converter)
                constructor = str2func(converterClazz);
                obj.converter = constructor(obj);
            end
        end
        
        function name = get.name(obj)
            name = obj.jBasic.getName();
        end
        
        function type = get.attributeType(obj)
            type = obj.jBasic.getAttributeType();
        end
    end
end

