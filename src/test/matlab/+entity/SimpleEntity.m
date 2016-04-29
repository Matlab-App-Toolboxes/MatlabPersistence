classdef SimpleEntity < H5Entity

	properties
		integers 
		doubles  
		strings  
	end

	properties
		identifier
		group = TestPersistence.SIMPLE_ENTITY;
		schema
	end

	methods
		
		function createSchema(obj)
            f = fields(obj.schema);
			if numel(f) ~= sum(ismember(f,  properties(obj)))
            	% throw exception
            end
            obj.createCompundSchema();
		end

		function getPersistanceData(obj)
		end

		function setQueryResponse(obj, rdata, n)
		end 
	end
end