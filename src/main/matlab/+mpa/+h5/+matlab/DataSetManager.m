classdef DataSetManager < handle
    
    properties(Access = private)
        elementCollections
        fname
    end
    
    methods
        
        function obj = DataSetManager(fname, elementCollections)
            obj.elementCollections = elementCollections;
            obj.fname = fname;
        end
        
        function find(obj, entity)
        end
        
        function save(obj, entity)
        end
        
    end
end

