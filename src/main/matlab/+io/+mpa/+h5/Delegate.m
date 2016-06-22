classdef Delegate < handle
    
    properties
        attributeManager
        dataSetManager
        queryManager
    end
    
    methods
        
        function obj = Delegate()
            obj.attributeManager = io.mpa.h5.AttributeManager();
            obj.dataSetManager = io.mpa.h5.DataSetManager();
        end
        
        function manager = getManager(mapper, types)
            metaModel = class(types(1));
            
            switch metaModel
                case 'io.mpa.core.metamodel.Basic'
                    manager = obj.attributeManager;
                case 'io.mpa.core.metamodel.ElementCollection'
                    manager = obj.dataSetManager;
            end
            
            manager.clear();
            manager.types = types;
            manager.mapper = mapper;
        end
    end
end