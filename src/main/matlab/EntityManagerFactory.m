classdef EntityManagerFactory < handle
    
    properties(SetAccess = private)
        persistence
        locations
    end
    
    methods

        function obj = EntityManagerFactory(h5properties)

        end
        
        function em = create(obj, id)
            
            for i = 1:numel(obj.locations)
                if strcmp(obj.locations{i}.id, id)
                    obj.fname = obj.locations{i}.local_path;
                    break;
                end
            end
         
            if isempty(obj.fname)
                msgID = 'Invalid File';
                msg = 'Unable to find File present in h5properties.json';
                throw (MException(msgID, msg));
            end
            em = H5EntityManager(obj.fname, obj.persistence);
        end
    end
end