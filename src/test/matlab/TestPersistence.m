classdef TestPersistence

    enumeration
    	
    	SIMPLE_ENTITY([...
    		H5DataType.INTEGER_GROUP.map('integers') ...
            H5DataType.DOUBLE_GROUP.map('doubles') ...
            H5DataType.STRING_GROUP.map('strings') ... 	
            ])
    end
    
    properties
    	schema
	end
    
    methods

        function obj = TestPersistence(str)
        	obj.schema = loadjson(['{' str(1 : end -1) '}']);
    	end
    end
end
