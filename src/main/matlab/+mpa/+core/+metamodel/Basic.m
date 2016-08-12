classdef Basic < handle
    
    properties(Access = private)
        jBasic
    end
    
    properties(Dependent)
        name
        attributeType
        field
    end
    
    properties(SetAccess = private)
        converter
    end
    
    methods
        
        function obj = Basic(jBasic)
            obj.jBasic = jBasic;
            converter = obj.jBasic.getConverter();
            
            if ~ isempty(converter)
                constructor = str2func(char(converter.getClazz()));
                obj.converter = constructor(obj);
            end
        end
        
        function name = get.name(obj)
            name = char(obj.jBasic.getName());
        end
        
        function type = get.attributeType(obj)
            type = char(obj.jBasic.getAttributeType());
        end
        
        function field = get.field(obj)
            field = char(obj.jBasic.getField());
        end
    end
end

