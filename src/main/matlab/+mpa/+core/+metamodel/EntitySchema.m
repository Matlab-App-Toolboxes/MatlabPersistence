classdef EntitySchema < handle
    
    properties(Access = private)
        jEntity
    end
    
    properties(SetAccess = private)
        basics
        elementCollections
        basicId
    end
    
    properties(Dependent)
        class
        prePersist
        postPersist
        postLoad
        id
        dataManager
        name
    end
    
    methods
        
        function obj = EntitySchema(jEntity)
            obj.jEntity = jEntity;
            obj.populateAttributes();
        end
        
        function class = get.class(obj)
            class = char(obj.jEntity.getClazz());
        end
        
        function h = get.prePersist(obj)
            h = obj.jEntity.getPrePersist().methodName();
        end
        
        function h = get.postPersist(obj)
            h = obj.jEntity.getPostPersist().methodName();
        end
        
        function h = get.postLoad(obj)
            h = obj.jEntity.getPostLoad().methodName();
        end
        
        function id = get.id(obj)
            id = obj.basicId;
        end
        
        function dataManager = get.dataManager(obj)
            dataManager = char(obj.jEntity.getDataManager().get(0).getClazz());
        end

        function name = get.name(obj)
            name = obj.jEntity.getName();
        end
    end
    
    methods(Access = private)
        
        function populateAttributes(obj)
            import mpa.core.metamodel.*;
            
            obj.basicId = Basic(obj.jEntity.getAttributes().getId().get(0));
            
            jList = obj.jEntity.getAttributes().getBasic();
            obj.basics = Basic.empty(0, jList.size());
            jIterator = jList.iterator;
            
            idx = 1;
            while jIterator.hasNext()
                obj.basics(idx) = Basic(jIterator.next());
                idx = idx + 1;
            end
            
            jList = obj.jEntity.getAttributes().getElementCollection();
            obj.elementCollections = ElementCollection.empty(0, jList.size());
            jIterator = jList.iterator;
            
            idx = 1;
            while jIterator.hasNext()
                obj.elementCollections(idx) = ElementCollection(jIterator.next());
                idx = idx + 1;
            end
        end
    end
    
    methods(Static)
        
        function clazz = getClazz(entityInstance)
            clazz = class(entityInstance);
            
            if isstruct(entityInstance)
                clazz = entityInstance.class;
            end
        end
    end
end