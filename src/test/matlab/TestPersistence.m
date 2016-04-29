classdef TestPersistence

    enumeration
    	
    	SIMPLE_ENTITY([ '{' ...
    		' "integers" : ' H5DataType.INTEGER_GROUP.toStr() ...
    		', "doubles" : ' H5DataType.DOUBLE_GROUP.toStr()....
    		', "strings" : ' H5DataType.STRING_GROUP.toStr() ...
    		'}' ])
    end
    
    properties
    	schema
	end
    
    methods

        function obj = TestPersistence(jsonSchema)
        	obj.schema = loadjson(jsonSchema);
    	end
    end
end
