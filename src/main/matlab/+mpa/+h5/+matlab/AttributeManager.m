classdef AttributeManager < handle
    
    properties(Access = private)
        basics
        fname
    end
    
    methods
        
        function obj = AttributeManager(fname, types)
            obj.basics = types;
            obj.fname = fname;
        end
        
        function find(obj, entity)
            group = entity.id;
            
            for basic = obj.basics
                entity.(basic.name) = h5readatt(obj.fname, group, basic.name);
            end
        end
        
        function save(obj, entity)
            group = entity.id;
            % TODO create group and write attributes
            
            for basic = obj.basics
                value = entity.(basic.name);
                h5writeatt(obj.fname, group, basic.name, value);
            end
        end
        
    end
end