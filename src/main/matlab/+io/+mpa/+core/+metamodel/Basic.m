classdef Basic < handle

    properties(Access = private)
    	jBasic
    end

    properties(Dependent)
    	name
    	attributeType
	end

    methods

    	function obj = Basic(jBasic)
    		obj.jBasic = jBasic;
    	end

    	function name = get.name(obj)
    		name = obj.jBasic.getName();
    	end

    	function type = get.attributeType(obj)
    		type = obj.jBasic.getAttributeType();
    	end
	end
end

