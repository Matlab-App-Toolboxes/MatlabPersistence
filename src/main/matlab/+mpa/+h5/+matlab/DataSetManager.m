classdef DataSetManager < mpa.h5.matlab.GroupManager
    
    properties(Access = private)
        elementCollections
    end
    
    methods
        
        function obj = DataSetManager(fname, elementCollections)
            obj@ mpa.h5.matlab.GroupManager(fname);
            obj.elementCollections = elementCollections;
            
        end
        
        function find(obj, entity)
        end
        
        function save(obj, entity)
        end
        
    end
end

