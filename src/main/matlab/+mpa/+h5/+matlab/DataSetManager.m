classdef DataSetManager < mpa.h5.matlab.GroupManager
    
    properties(Access = private)
        elementCollections
        dataType
    end
    
    methods
        
        function obj = DataSetManager(fname)
            obj@ mpa.h5.matlab.GroupManager(fname);
        end
        
        function init(obj, schema)
            obj.elementCollections = schema.elementCollections;
            obj.dataType = obj.elementCollections.attributeType;
        end
        
        function entity = find(obj, entity)
            
            fid = H5F.open(obj.fname, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
            dset = H5D.open(fid, [entity.id '/' mpa.core.Constants.DATA_SET_NAME]);
            
            [types, size] = obj.getH5ComplexType();
            % Create the compound datatype for memory.
            
            memtype = H5T.create('H5T_COMPOUND', size);
            arrayfun(@(type) H5T.insert(memtype, type.name, type.offset, type.dataType), types);
            
            data = H5D.read(dset, memtype, 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');
            
            for i = 1 : numel(obj.elementCollections)
                collection = obj.elementCollections(i);
                entity.(collection.name) =  data.(collection.name);
            end
            
            H5D.close(dset);
            H5T.close(memtype);
            H5F.close(fid);
            
        end
        
        function entity = save(obj, entity)
            group = entity.id;
            obj.createGroup(group);
            
            [types, size] = obj.getH5ComplexType();
            dims = numel(entity.(obj.elementCollections(1).name));
            
            data = struct();
            collections = obj.elementCollections;
            
            for i = 1 : numel(collections)
                collection = collections(i);
                data.(collection.name) = entity.(collection.name);
            end
            
            % Create the compound datatype for memory.
            
            memtype = H5T.create('H5T_COMPOUND', size);
            arrayfun(@(type) H5T.insert(memtype, type.name, type.offset, type.dataType), types);
            
            % Create the compound datatype for the file.  Because the standard
            % types we are using for the file may have different sizes than
            % the corresponding native types, we must manually calculate the
            % offset of each member.
            
            filetype = H5T.create('H5T_COMPOUND', size);
            arrayfun(@(type) H5T.insert(filetype, type.name, type.offset, type.dataType), types);
            
            % Create dataspace.  Setting maximum size to [] sets the maximum
            % size to be the current size
            
            space = H5S.create_simple(1,fliplr(dims), []);
            fid = H5F.open(obj.fname, 'H5F_ACC_RDWR', 'H5P_DEFAULT');
            
            dset = H5D.create(fid, [group '/' mpa.core.Constants.DATA_SET_NAME], filetype, space, 'H5P_DEFAULT');
            H5D.write(dset, memtype, 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT', data);
            
            H5D.close(dset);
            H5S.close(space);
            H5T.close(filetype);
            H5T.close(memtype);
            H5F.close(fid);
            
        end
        
        function [types, size] = getH5ComplexType(obj)
            collections = obj.elementCollections;
            n = numel(collections);
            size = 0;
            types = struct('name', {}, 'offset', {}, 'dataType', {});
            
            %Create the required data types and offset
            
            for i = 1 : n
                collection = collections(i);
                types(i).offset = size;
                types(i).name = collection.name;
                
                switch(collection.attributeType)
                    case 'int'
                        intType = H5T.copy('H5T_NATIVE_INT');
                        size = size + H5T.get_size(intType);
                        types(i).dataType = intType;
                        
                    case 'string'
                        strType = H5T.copy('H5T_C_S1');
                        H5T.set_size(strType, 'H5T_VARIABLE');
                        size = size + H5T.get_size(strType);
                        types(i).dataType = strType;
                        
                    case 'double'
                        doubleType = H5T.copy('H5T_NATIVE_DOUBLE');
                        size = size + H5T.get_size(doubleType);
                        types(i).dataType = doubleType;
                end
            end
            
        end
        
        function close(obj, ~)
            obj.elementCollections = [];
            obj.dataType = [];
        end
        
    end
end

