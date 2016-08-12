classdef H5MatlabProvider < mpa.core.AbstractProvider
    
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
        end
        
        function manager = getManager(obj, types)
            
            if ~ exist(obj.localPath, 'file')
                error('Matlab:persistence:filenotfound', 'h5 file not found');
            end
            manager = mpa.h5.matlab.createManager(obj.localPath, types);
        end
        
        function close(obj)
            % TODO synchronize to server
        end
    end
    
end

