classdef EntityManagerFactory < handle
    
    properties(SetAccess = private)
        fileProperties
        persistenceClass
    end
    
    methods
        
        function obj = EntityManagerFactory(fileProperties, persistenceClass)
            obj.fileProperties = fileProperties;
            obj.persistenceClass = persistenceClass;
        end
        
        function em = create(obj, id, entityMap)
            
            for i = 1:numel(obj.fileProperties)
                if strcmp(obj.fileProperties{i}.id, id)
                    fname = obj.fileProperties{i}.local_path;
                    break;
                end
            end
            
            if isempty(fname)
                msgID = 'Invalid File';
                msg = 'Unable to find File present in h5properties.json';
                throw (MException(msgID, msg));
            end
            em = io.mpa.H5EntityManager(fname, entityMap);
        end
    end
end