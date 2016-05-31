classdef EntityManagerFactory < handle

	properties(SetAccess = 'private')
        persistenceCore
	end

	methods

		function obj = EntityManagerFactory(persistenceCore)
            obj.persistenceCore = persistenceCore;
        end

		function em = getEntityManager(obj, unitName)
			ds = obj.persistenceCore.getDataSource(unitName)
			% Todo think about entity manger work flow
		end
	end
end