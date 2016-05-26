classdef (Abstract)Persistence < handle

	properties
		entities
	end

	methods
		function obj = Persistence(entities)
			obj.entities = entities;
		end
	end

	methods(Static)
		function emf = getEntityManagerFactory(h5name)
			persistent factory;			
			if isempty(factory)
				factory =  io.mpa.EntityManagerFactory(h5name);
			end
			emf = factory;
		end
	end
end