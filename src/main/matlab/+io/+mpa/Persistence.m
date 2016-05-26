classdef (Abstract)Persistence < handle

	properties
		entities
	end

	methods
		function obj = Persistence(entities)
			obj.entities = entities;
		end
	end
end