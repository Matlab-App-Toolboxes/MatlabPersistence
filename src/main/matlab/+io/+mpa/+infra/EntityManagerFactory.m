classdef EntityManagerFactory < handle
    
    properties(SetAccess = 'private')
        context
        persistenceCore
        persistenceProperties
    end
    
    methods
        
        function obj = EntityManagerFactory(unitName)
            obj.persistenceCore = io.mpa.core.PersistenceCore();
            obj.persistenceProperties = p.getPersistenceProperties(unitName);
            obj.context = io.mpa.infra.PersistenceContext();
        end
        
        function em = getEntityManager(obj, unitName)
            
            if obj.context.hasEntityManager(unitName)
                em = obj.context.getEntityManager(unitName);
                return
            end
            ds = obj.context.getDataSource(unitName);
            em = io.mpa.manager.EntityManager(ds);
            obj.context.addEntityManager(em);
        end
    end
end