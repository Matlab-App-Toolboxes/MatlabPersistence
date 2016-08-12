classdef AbstractProvider < handle
    
    properties(SetAccess = private)
        useCache
        localPath
        remotePath
        shouldCreateEntites
        description
    end
    
    methods
        
        function init(obj, map)
            
            import mpa.core.*;
            obj.description = char(map(mpa.core.PersistenceUnit.PERSISTENCE_NAME));
            
            obj.localPath = char(map(Constants.PROVIDER_LOCAL_PATH));
            obj.remotePath = char(map(Constants.PROVIDER_REMOTE_PATH));
            obj.shouldCreateEntites = strcmp(map(Constants.PROVIDER_CREATE_MODE), 'true');
            obj.useCache = char(map(Constants.PROVIDER_USE_CACHE));
            
            if ~ exist(obj.localPath, 'file')
                obj.createDefintion();
            end
            
            if obj.shouldCreateEntites
                entityMap = map(mpa.core.PersistenceUnit.ENTITIES);
                obj.createEntites(entityMap);
            end
        end
    end
    
    methods(Abstract)
        createDefintion(obj)
        createEntites(obj, entityMap)
        getManager(obj, types)
        close(obj)
    end
end

