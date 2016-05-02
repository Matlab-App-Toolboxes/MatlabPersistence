classdef Persistence
    
    enumeration
    	a
    end
    
    methods

        function path = toPath(obj)
            path = ['/' char(obj) '/'];
        end
    end

    methods(Static)

    	function obj = createEntityManagerFactory(id, h5properties)
    		if nargin < 2
    		     cp = getClassPath();
    		     h5properties = [cp.resources 'h5properties.json'];
    		end
    		
    		json = loadjson(h5properties);
    		obj.locations = json.location;
    		obj.persistence = enumeration('Persistence');
    	end
	end
end

