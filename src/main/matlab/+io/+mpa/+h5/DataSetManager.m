classdef DataSetManager < H5Object
    
    properties(Constant)
        SEPERATOR = '\'
    end
    
    properties(Dependent)
        elementCollections
        memType
    end
    
    properties(SetAcces = private)
        space
    end
    
    methods
        
        function find(obj, entity)
            group = mapper.getGroup(entity);
            ds = mapper.getDataSet(entity);

        end
        
        function save(obj, entity)
            group = mapper.getGroup(entity);
            ds = mapper.getDataSet(entity);
            
            data = struct();
            for collection = obj.elementCollections
                value = entity.(collection.name);
                data.(collection.name) = value;
                size = numel(value);
            end
            
            obj.space = H5S.create_simple(1, fliplr(size), []);
            obj.createGroup(group);
            obj.createDataSet(ds);
            
            
        end
        
        function c = get.elementCollections(obj)
            c = obj.types;
        end
        
        function m = get.memType(obj)
            size = ones(1, numel(obj.types));
            
            i = 1;
            for collections = obj.elementCollections
                type = collections.attributeType;
                h5type = io.mpa.h5.constants.DataType.(type);
                size(i) = h5type.getSize();
                i = i + 1;
            end
            
            offset(1) = 0;
            offset(2 : n) = cumsum(size(1 : n-1));
            filetype = H5T.create('H5T_COMPOUND', sum(size));
            
            i = 1;
            for collections = obj.elementCollections
                H5T.insert(filetype, collections.name, offset(i), h5type.name);
                i = i + 1;
            end
            m = filetype;
        end
    end
end

