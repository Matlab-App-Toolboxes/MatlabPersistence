classdef AttributeManager < H5Object
    
    properties(Constant)
        SEPERATOR = '\'
    end
    
    properties(Dependent)
        basics
    end
    
    methods
        
        function save(obj, entity)
            group = mapper.getGroup(entity);
            ds = mapper.getDataSet();
            
            path = [group '/' dataSet];
            obj.createGroup(group);
            obj.createDataSet(ds);
            
            for basic = obj.basics
                value = entity.(basic.name);
                h5writeatt(obj.fname, path, basic.name, value);
            end
        end
        
        function b = get.basics(obj)
            b = obj.types;
        end
    end
end