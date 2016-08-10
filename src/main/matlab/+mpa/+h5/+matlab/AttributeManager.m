classdef AttributeManager < mpa.h5.matlab.GroupManager
    
    properties(Access = private)
        basics
    end
    
    methods
        
        function obj = AttributeManager(fname, types)
            obj@ mpa.h5.matlab.GroupManager(fname)
            obj.basics = types;
        end
        
        function entity = find(obj, entity)
            group = entity.id;
            
            for basic = obj.basics
                entity.(basic.name) = h5readatt(obj.fname, group, basic.name);
            end
        end
        
        function save(obj, entity)
            group = entity.id;
            obj.createGroup(group); 
            
            h5writeatt(obj.fname, group, 'id', group);
            for basic = obj.basics
                value = entity.(basic.name);
                h5writeatt(obj.fname, group, basic.name, value);
            end
        end
        
    end
end