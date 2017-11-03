classdef SqlliteTableManager < handle
    
    properties
    	jStatement
    end
    
    methods
    	
    	function obj = SqlliteTableManager(jStatement)
    		obj.jStatement = jStatement;
    	end

    	function close(obj)
    	end 
    end
    
end

