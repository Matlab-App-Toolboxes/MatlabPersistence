classdef H5EntityManager < handle

    properties
        fname
        persistence
    end

    methods

        function obj = H5EntityManager(fname, persistence)
            obj.fname = fname;
            obj.persistence = persistence;
        end

        function create(obj)
            file = H5F.create(obj.fname, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

            p = enumeration(obj.persistance);
            for i = 1:numel(p)
                group = H5G.create(file, p(i).toPath(), 0);
                H5G.close(group);
            end
            H5F.close(file);
        end

        function insertCompoundDataSet(obj, h5Entity)

            if ~ exist(obj.fname, 'file')
                obj.createFile(obj.fname)
            end
            [data, size] = h5Entity.get('dataSet');
            
            memtype = obj.createH5Types(h5Entity.schema);
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

            if ~ exist(obj.fname, 'file')
                obj.createFile(obj.fname)
            end
            [data, size] = h5Entity.get('dataSet');
            memtype = obj.createH5Types(h5Entity.schema);

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

            file = H5F.open(obj.fname, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
            dset = H5D.open(file, [h5Entity.group '/' h5Entity.identifier]);
            space = H5D.get_space(dset);
            [~, dims, ~] = H5S.get_simple_extent_dims(space);
            dims = fliplr(dims);
   
            memtype = obj.createH5Types(h5Entity.schema);
            rdata = H5D.read(dset, memtype, 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');         
            h5Entity.setQueryResponse(rdata, dims);

            H5D.close(dset);
            H5S.close(space);
            H5T.close(memtype);
            H5F.close(file);
        end

        function findCompoundAttributes(obj, h5Entity)

            file = H5F.open(obj.fname, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
            dset = H5D.open(file, [h5Entity.group '/' h5Entity.identifier]);
            attr = H5A.open_name(dset, 'attributes');
            space = H5A.get_space(attr);
            [~, dims, ~] = H5S.get_simple_extent_dims(space);
            dims = fliplr(dims);

            memtype = h5Entity.createH5Types();
            rdata = H5A.read(attr, memtype);
            h5Entity.setQueryResponse(rdata, dims);

            H5A.close (attr);
            H5D.close (dset);
            H5S.close (space);
            H5T.close (memtype);
            H5F.close (file);
        end

        function sz = getH5Size(obj, schema)

            fields = fields(schema);
            n = numel(fields)
            sz = ones(1, n);
            
            for i = 1 : n
                h5DataType = schema.(fields{i});

                switch h5DataType
                    
                    case H5DataType.DOUBLE_GROUP
                        doubleType = H5T.copy('H5T_NATIVE_DOUBLE');
                        sz(i)= H5T.get_size(doubleType);
                    
                    case H5DataType.INTEGER_GROUP
                        intType = H5T.copy('H5T_NATIVE_INT');
                        sz(i)= H5T.get_size(intType);
                end
            end
        end

        function filetype = createH5Types(obj, schema)

            sz = obj.getH5Size(schema);
            offset(1) = 0;
            offset(2 : n) = cumsum(sz(1 : n-1));
            filetype = H5T.create ('H5T_COMPOUND', sum(sz));
            
            for i = 1 : n
                h5DataType = schema.(fields{i});
                H5T.insert(filetype, fields{i}, offset(i), h5DataType.type);
            end
        end
    end
end