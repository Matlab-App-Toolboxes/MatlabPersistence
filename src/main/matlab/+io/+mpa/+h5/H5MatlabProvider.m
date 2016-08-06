classdef H5MatlabProvider < handle
    
    properties(SetAccess = private)
        useCache
        localPath
        remotePath
        createMode
    end
    
    methods
        
        function init(obj, map)
            import io.mpa.h5.*;
            
            obj.localPath = map(Constants.PROVIDER_LOCAL_PATH);
            obj.remotePath = map(Constants.PROVIDER_REMOTE_PATH);
            obj.createMode = map(Constants.PROVIDER_CREATE_MODE);
            obj.objectCache = containers.Map(Constants.PROVIDER_USE_CACHE);
            
            if ~ exist(obj.localPath, 'file') && obj.createMode
                obj.createFile(map(PersistenceUnit.ENTITIES));
            end
        end
        
        function manager = delegate(obj, types)
            
            if ~ exist(obj.localPath, 'file')
                error('Matlab:persistence:filenotfound', 'h5 file not found');
            end
            manager = io.mpa.h5.matlab.createManager(obj.localPath, types);
        end
        
        function close(obj)
            % TODO synchronize to server
        end
    end
    
end

