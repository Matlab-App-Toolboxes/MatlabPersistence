classdef MatlabPersistence< handle
    
    properties
        persistence
    end
    
    methods
        function obj = MatlabPersistence(factory)
            obj.persistence = persistence;
        end
    end
    
    methods(Static)
        
        function emf = createEntityManagerFactory(fname, unitName)
            persistent entityManagerFactory;
            
            javaaddpath(which('mpa-h5-orm-0.0.1-SNAPSHOT'));
            import io.mpa.factory.*;
            if isempty(entityManagerFactory)
                factory = PersistenceFactory(java.lang.String(fname));
                p = io.mpa.MatlabPersistence(factory);
                entityManagerFactory = io.mpa.EntityManagerFactory(p, unitName);
            end
            emf = entityManagerFactory;
        end
    end
end