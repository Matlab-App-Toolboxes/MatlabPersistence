classdef H5MatlabProvider < handle
    
    properties(SetAccess = private)
        useCache
        localPath
        remotePath
        shouldCreateEntites
        description
    end
    
    methods
        
        function init(obj, map)
            import mpa.h5.*;
            obj.description = char(map(mpa.core.PersistenceUnit.PERSISTENCE_NAME));
            
            obj.localPath = char(map(Constants.PROVIDER_LOCAL_PATH));
            obj.remotePath = char(map(Constants.PROVIDER_REMOTE_PATH));
            obj.shouldCreateEntites = strcmp(map(Constants.PROVIDER_CREATE_MODE), 'true');
            obj.useCache = char(map(Constants.PROVIDER_USE_CACHE));
            
            if ~ exist(obj.localPath, 'file') 
                obj.createFile();
            end
            
            if obj.shouldCreateEntites
                entities = map(mpa.core.PersistenceUnit.ENTITIES);
                manager = matlab.GroupManager(obj.localPath);
                for i = 1 : numel(entities)
                    e = entities{i};
                    group = matlab.lang.makeValidName(e);
                    manager.createGroup(['/' group]);
                end
            end
        end
        
        function manager = delegate(obj, types)
            
            if ~ exist(obj.localPath, 'file')
                error('Matlab:persistence:filenotfound', 'h5 file not found');
            end
            manager = mpa.h5.matlab.createManager(obj.localPath, types);
        end
        
        function createFile(obj)
            fid = H5F.create(fullfile(obj.localPath), 'H5F_ACC_TRUNC','H5P_DEFAULT','H5P_DEFAULT');
            H5F.close(fid);
            h5writeatt(obj.localPath, '/', 'version', 1)
            h5writeatt(obj.localPath, '/', 'description', obj.description)
        end
        
        
        function close(obj)
            % TODO synchronize to server
        end
    end
    
end

