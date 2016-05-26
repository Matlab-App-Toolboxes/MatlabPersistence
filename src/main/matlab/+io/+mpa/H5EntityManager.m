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
        
        function createFile(obj)
            file = H5F.create(obj.fname, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');
            
            e = values(obj.entityMap);
            for i = 1:numel(e)
                group = H5G.create(file, e{i}.toPath(), 0);
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
                obj.createFile();
            end
            
            [data, size] = h5Entity.toStructure(schema);
            memtype = obj.createH5Types(schema);
            
            file = H5F.open(obj.fname, 'H5F_ACC_RDWR','H5P_DEFAULT');
            space = H5S.create_simple(1, fliplr(size), []);
            
            if ~ h5Entity.isGroupCreated
                group = H5G.create(file, h5Entity.group, 0);
                dset = H5D.create(group, h5Entity.identifier, memtype, space, 'H5P_DEFAULT');
                h5Entity.isGroupCreated = true;
                h5Entity.isIdentifierCreated = true;
                
            elseif ~ h5Entity.isIdentifierCreated
                 group = H5G.open(file, h5Entity.group, 0);
                 dset = H5D.create(group, h5Entity.identifier, memtype, space, 'H5P_DEFAULT');
                 h5Entity.isIdentifierCreated = true;
                 
            else
                group = H5G.open(file, h5Entity.group, 0);
                dset = H5D.open(group, h5Entity.identifier, 'H5P_DEFAULT');
            end
            
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
                obj.createFile();
            end
            
            [data, size] =  h5Entity.toStructure(schema);
            memtype = obj.createH5Types(schema);
            
            file = H5F.open(obj.fname, 'H5F_ACC_RDWR','H5P_DEFAULT');
            space = H5S.create ('H5S_SCALAR');
            
            if ~ h5Entity.isGroupCreated
                group = H5G.create(file, h5Entity.group, 0);
                dset = H5D.create(group, h5Entity.identifier, 'H5T_STD_I32LE', space, 'H5P_DEFAULT');
                
                h5Entity.isGroupCreated = true;
                h5Entity.isIdentifierCreated = true;
                
            elseif ~ h5Entity.isIdentifierCreated
                group = H5G.open(file, h5Entity.group, 0);
                dset = H5D.create(group, h5Entity.identifier, 'H5T_STD_I32LE', space, 'H5P_DEFAULT');
                h5Entity.isIdentifierCreated = true;
                
            else
                group = H5G.open(file, h5Entity.group, 0);
                dset = H5D.open(group, h5Entity.identifier, 'H5P_DEFAULT');
            end
            
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
            h5Entity.setQueryResponse(rdata, schema);
            
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
            h5Entity.setQueryResponse(rdata, schema);
            
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
        
        function insertSimpleAttributes(obj, h5Entity)
            schema = h5Entity.getSchema(io.mpa.H5DataClass.SIMPLE_ATTR);
            
            if ~ exist(obj.fname, 'file')
                obj.createFile();
            end
            
            if isempty(schema)
                return;
            end
            [data, size] =  h5Entity.toStructure(schema);
            props = fields(data);
            file = H5F.open(obj.fname, 'H5F_ACC_RDWR','H5P_DEFAULT');
            space = H5S.create ('H5S_SCALAR');
            
            if ~ h5Entity.isGroupCreated
                group = H5G.create(file, h5Entity.group, 0);
                dset = H5D.create(group, h5Entity.identifier, 'H5T_STD_I32LE', space, 'H5P_DEFAULT');
                
                h5Entity.isGroupCreated = true;
                h5Entity.isIdentifierCreated = true;
                
            elseif ~ h5Entity.isIdentifierCreated
                group = H5G.open(file, h5Entity.group, 0);
                dset = H5D.create(group, h5Entity.identifier, 'H5T_STD_I32LE', space, 'H5P_DEFAULT');
                h5Entity.isIdentifierCreated = true;
            end
            H5F.close(file);
            
            % ToDo rewrite h5writeatt to core librarires
            for i = 1:numel(props)
                h5writeatt(obj.fname, h5Entity.key, props{i}, data.(props{i}));
            end
        end
        
        function findSimpleAttributes(obj, h5Entity)
            schema = h5Entity.getSchema(io.mpa.H5DataClass.SIMPLE_ATTR);
            
            if isempty(schema)
                return;
            end
            props = fields(schema);
            
            % ToDo rewrite h5readatt to core librarires
            for i = 1:numel(props)
                rdata.(props{i}) = h5readatt(obj.fname, h5Entity.key , props{i});
            end
            h5Entity.setQueryResponse(rdata, schema);
        end
       
       
        function persist(obj, h5Entity)
            h5Entity.prePersist();           
            
            obj.insertCompoundDataSet(h5Entity);
            obj.insertCompoundAttributes(h5Entity);
            obj.insertSimpleAttributes(h5Entity);
            
            h5Entity.postPersist();  
        end
        
        function find(obj, h5Entity)
            h5Entity.preFind();         
            
            obj.findSimpleAttributes(h5Entity);
            obj.findCompoundDataSet(h5Entity);
            obj.findCompoundAttributes(h5Entity);
            
            h5Entity.postFind(); 
        end
        
        function result = executeQuery(obj, query)
            result = query(obj.fname);
        end
    end
end