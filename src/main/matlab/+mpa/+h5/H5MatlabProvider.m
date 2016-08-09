classdef H5MatlabProvider < handle
    
    properties(SetAccess = private)
        useCache
        localPath
        remotePath
        createMode
    end
    
    methods
        
        function init(obj, map)
            import mpa.h5.*;
            
            obj.localPath = char(map(Constants.PROVIDER_LOCAL_PATH));
            obj.remotePath = char(map(Constants.PROVIDER_REMOTE_PATH));
            obj.createMode = strcmp(map(Constants.PROVIDER_CREATE_MODE), 'true');
            obj.useCache = char(map(Constants.PROVIDER_USE_CACHE));
            
            if ~ exist(obj.localPath, 'file') && obj.createMode
                obj.createFile(map(mpa.core.PersistenceUnit.ENTITIES));
            end
        end
        
        function manager = delegate(obj, types)
            
            if ~ exist(obj.localPath, 'file')
                error('Matlab:persistence:filenotfound', 'h5 file not found');
            end
            manager = mpa.h5.matlab.createManager(obj.localPath, types);
        end
        
        function createFile(obj, entities)
            
        end
        
        function close(obj)
            % TODO synchronize to server
        end
    end
    
end

