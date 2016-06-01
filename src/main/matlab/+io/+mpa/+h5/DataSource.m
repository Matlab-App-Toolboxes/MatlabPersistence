classdef DataSource < handle
	
	properties(SetAccess = private)
		localPath
		remotePath
		entities
		propertyMap
	end

	methods

		function obj = DataSource(entities, propertyMap)
			obj.localPath = propertyMap('localPath');
			obj.remotePath = propertyMap('remotePath');
			obj.entities = entities;
			obj.propertyMap = propertyMap;
		end
	end
end