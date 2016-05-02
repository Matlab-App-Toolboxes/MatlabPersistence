classdef H5DataType
	
	enumeration
		INTEGER_GROUP('intType')
		STRING_GROUP('strType')
		DOUBLE_GROUP('doubleType')
	end	

	properties
		type
	end 

	methods

		function obj = H5DataType(type)
			obj.type = type;
		end

		function str = map(obj, property)
			str = ['"' property '" : "' char(obj) '" ,'];
		end
	end
end