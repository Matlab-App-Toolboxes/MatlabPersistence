classdef SimpleEntity < H5Entity

	properties
		integers 
		doubles  
		strings
		id  
	end

	properties(Dependent)
		identifier
		group
		schema
	end

	methods

		function getPersistanceData(obj)
		end

		function setQueryResponse(obj, rdata, n)
		end 

		function id = get.identifier(obj)
			id = obj.id;
		end

		function group = get.group(obj)
			group = TestPersistence.SIMPLE_ENTITY;
		end
	end
end