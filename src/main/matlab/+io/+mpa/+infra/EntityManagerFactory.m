classdef EntityManagerFactory < handle

	properties(SetAccess = 'private')
        context
	end

	methods

		function obj = EntityManagerFactory(persistenceContext)
            obj.context = persistenceContext;
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