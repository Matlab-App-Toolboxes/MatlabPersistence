classdef AttributeManager < mpa.h5.matlab.GroupManager
    
    properties(Access = private)
        basics
    end
    
    methods
        
        function obj = AttributeManager(fname)
            obj@ mpa.h5.matlab.GroupManager(fname);
        end
        
        
        function init(obj, schema)
            obj.basics = schema.basics;
        end
        
        function entity = find(obj, entity)
            group = entity.id;
            
            for basic = obj.basics
                entity.(basic.name) = h5readatt(obj.fname, group, basic.name);
            end
        end
        
        function entity = save(obj, entity)
            group = entity.id;
            obj.createGroup(group);
            
            h5writeatt(obj.fname, group, 'id', group);
            for basic = obj.basics
                value = entity.(basic.name);
                h5writeatt(obj.fname, group, basic.name, value);
            end
        end
        
        function close(obj, ~)
            obj.basics = [];
        end
        
    end
end