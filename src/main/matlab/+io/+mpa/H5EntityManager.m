classdef H5EntityManager < handle
    
    properties
        fname
        entityMap
    end
    
    methods
        
        function obj = H5EntityManager(fname, entityMap)
            obj.fname = fname;
            obj.entityMap = entityMap;
        end
        
        function create(obj)
            file = H5F.create(obj.fname, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');
            
            e = values(obj.entityMap);
            for i = 1:numel(e)
                group = H5G.create(file, e(i).toPath(), 0);
                H5G.close(group);
            end
            H5F.close(file);
        end
        
        function insertCompoundDataSet(obj, h5Entity)
            schema = h5Entity.getSchema(io.mpa.H5DataClass.COMPOUND_DS);
            
            if isempty(schema)
                return;
            end
            
            if ~ exist(obj.fname, 'file')
                obj.createFile(obj.fname)
            end
            
            [data, size] = h5Entity.toStructure(schema);
            memtype = obj.createH5Types(schema);
            
            file = H5F.open(obj.fname, 'H5F_ACC_RDWR','H5P_DEFAULT');
            space = H5S.create_simple(1, fliplr(size), []);
            group = H5G.create(file, h5Entity.group, 0);
            dset = H5D.create(group, h5Entity.identifier, memtype, space, 'H5P_DEFAULT');
            
            H5D.write(dset, memtype, 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT', data);
            
            H5D.close(dset);
            H5S.close(space);
            H5G.close(group);
            H5T.close(memtype);
            H5F.close(file);
        end
        
        function insertCompoundAttributes(obj, h5Entity)
            schema = h5Entity.getSchema(io.mpa.H5DataClass.COMPOUND_ATTR);
            
            if isempty(schema)
                return;
            end
            
            if ~ exist(obj.fname, 'file')
                obj.createFile(obj.fname)
            end
            
            [data, size] =  h5Entity.toStructure(schema);
            memtype = obj.createH5Types(schema);
            
            file = H5F.open(obj.fname, 'H5F_ACC_RDWR','H5P_DEFAULT');
            space = H5S.create ('H5S_SCALAR');
            group = H5G.create(file, h5Entity.group, 0);
            dset = H5D.create(group, h5Entity.identifier, 'H5T_STD_I32LE', space, 'H5P_DEFAULT');
            H5S.close(space);
            
            space = H5S.create_simple(1, fliplr(size), []);
            attr = H5A.create(dset, 'attributes', memtype, space, 'H5P_DEFAULT');
            H5A.write(attr, memtype, data);
            
            H5A.close(attr);
            H5D.close(dset);
            H5S.close(space);
            H5T.close(memtype);
            H5G.close(group);
            H5F.close(file);
        end
        
        function findCompoundDataSet(obj, h5Entity)
            schema = h5Entity.getSchema(io.mpa.H5DataClass.COMPOUND_DS);
            
            if isempty(schema)
                return;
            end
            
            file = H5F.open(obj.fname, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
            dset = H5D.open(file, [h5Entity.group '/' h5Entity.identifier]);
            space = H5D.get_space(dset);
            [~, dims, ~] = H5S.get_simple_extent_dims(space);
            dims = fliplr(dims);
            
            memtype = obj.createH5Types(schema);
            rdata = H5D.read(dset, memtype, 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');
            h5Entity.setQueryResponse(rdata, dims);
            
            H5D.close(dset);
            H5S.close(space);
            H5T.close(memtype);
            H5F.close(file);
        end
        
        function findCompoundAttributes(obj, h5Entity)
            schema = h5Entity.getSchema(io.mpa.H5DataClass.COMPOUND_ATTR);
            
            if isempty(schema)
                return;
            end
            
            file = H5F.open(obj.fname, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
            dset = H5D.open(file, [h5Entity.group '/' h5Entity.identifier]);
            attr = H5A.open_name(dset, 'attributes');
            space = H5A.get_space(attr);
            [~, dims, ~] = H5S.get_simple_extent_dims(space);
            dims = fliplr(dims);
            
            memtype = obj.createH5Types(schema);
            rdata = H5A.read(attr, memtype);
            h5Entity.setQueryResponse(rdata, dims);
            
            H5A.close (attr);
            H5D.close (dset);
            H5S.close (space);
            H5T.close (memtype);
            H5F.close (file);
        end
        
        function filetype = createH5Types(~, schema)
            
            cols = fields(schema);
            n = numel(cols);
            sz = ones(1, n);
            
            for i = 1 : n
                h5DataType = io.mpa.H5DataType.(schema.(cols{i}));
                sz(i) = h5DataType.getSize();
            end
            offset(1) = 0;
            offset(2 : n) = cumsum(sz(1 : n-1));
            filetype = H5T.create('H5T_COMPOUND', sum(sz));
            
            for i = 1 : n
                h5DataType = io.mpa.H5DataType.(schema.(cols{i}));
                H5T.insert(filetype, cols{i}, offset(i), h5DataType.type);
            end
        end
        
        function insertSimpleAttribute(obj, h5Entity)
            schema = h5Entity.getSchema(io.mpa.H5DataClass.SIMPLE_ATTR);
            
            if isempty(schema)
                return;
            end
            cols = fields(schema);
            
            for i = 1:numel(cols)
                h5writeatt(obj.fname, [h5Entity.group '/' h5Entity.identifier], cols{i}, schema.cols{i});
            end
        end
        
        function findSimpleAttribute(obj, h5Entity)
            schema = h5Entity.getSchema(io.mpa.H5DataClass.SIMPLE_ATTR);
            
            if isempty(schema)
                return;
            end
            cols = fields(schema);
            
            for i = 1:numel(cols)
                rdata.(cols{i}) = h5readatt(obj.fname, [h5Entity.group '/' h5Entity.identifier], cols{i});
            end
            h5Entity.setQueryResponse(rdata, length(rdata.(cols{1})));
        end
        
        function persist(obj, h5Entity)
            obj.insertCompoundDataSet(h5Entity);
            obj.insertCompoundAttributes(h5Entity);
            obj.insertSimpleAttribute(h5Entity);
        end
        
        function find(obj, h5Entity)
            obj.findCompoundDataSet(h5Entity);
            obj.findCompoundAttributes(h5Entity);
            obj.findSimpleAttribute(h5Entity);
        end
    end
end