classdef TestPersistence

    enumeration
    	
    	SIMPLE_ENTITY([ '{' ...
    		' "integers" : { "type" : "intType", "class" : "complex"}, '...
    		' "doubles" : { "type" : "doubleType", "class" : "complex"}, '...
    		' "strings" : { "type" : "strType", "class" : "complex"} '...
    		'}' ])
    end
    
    properties
    	schema
	end
    
    methods

        function obj = TestPersistence(jsonSchema)
        	obj.schema = loadjson(jsonSchema);
    	end

        function path = toPath(obj)
            path = ['/' char(obj) '/'];
        end
    end
end
