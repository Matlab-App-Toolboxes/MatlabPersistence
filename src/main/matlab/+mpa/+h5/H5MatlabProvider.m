classdef H5MatlabProvider < mpa.core.AbstractProvider
    
    properties
        entityMap
    end
    
    methods
        
        function createDefintion(obj)
            fid = H5F.create(fullfile(obj.localPath), 'H5F_ACC_TRUNC','H5P_DEFAULT','H5P_DEFAULT');
            H5F.close(fid);
            h5writeatt(obj.localPath, '/', 'version', 1)
            h5writeatt(obj.localPath, '/', 'description', obj.description)
        end
        
        function createEntites(obj, entityMap)
            entities = entityMap.keys();
            manager = mpa.h5.matlab.GroupManager(obj.localPath);
            
            for i = 1 : numel(entities)
                e = entities{i};
                group = matlab.lang.makeValidName(e);
                manager.createGroup(['/' group]);
            end
            obj.entityMap = entityMap;
        end
        
        function manager = createEntityManager(obj)
            
            if ~ exist(obj.localPath, 'file')
                error('Matlab:persistence:filenotfound', 'h5 file not found');
            end
            manager = mpa.h5.matlab.EntityManager(obj.localPath, obj.entityMap);
        end
        
        function close(obj)
            % TODO synchronize with server
        end
    end
    
end

