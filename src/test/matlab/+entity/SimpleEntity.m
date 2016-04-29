classdef SimpleEntity < H5Entity

	properties
		integers 
		doubles  
		string  
	end

	properties
		identifier
		group
	end

	methods
		
		function createSchema(obj)
		end

		function getPersistanceData(obj)
		end

		function setQueryResponse(obj, rdata, n)
		end 
	end
end