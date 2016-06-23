classdef AttributeManager < H5Object
    
    properties(Constant)
        SEPERATOR = '\'
    end
    
    properties(Dependent)
        basics
        space
        memType
    end
    
    methods
        
        function find(obj, entity)
            group = mapper.getGroup(entity);
            ds = mapper.getDataSet(entity);    
            path = [group '/' ds];
            
            for basic = obj.basics
                entity.(basic.name) = h5readatt(obj.fname, path ,basic.name);
            end
        end
        
        function save(obj, entity)
            group = mapper.getGroup(entity);
            ds = mapper.getDataSet(entity);
            
            path = [group '/' ds];
            obj.createGroup(group);
            obj.createDataSet(ds);
            
            for basic = obj.basics
                value = entity.(basic.name);
                h5writeatt(obj.fname, path, basic.name, value);
            end
        end
        
        function s = get.space(~)
            s = H5S.create('H5S_SCALAR');
        end
        
        function m = get.memType(~)
            m = 'H5T_STD_I32LE';
        end
        
        function b = get.basics(obj)
            b = obj.types;
        end
    end
end