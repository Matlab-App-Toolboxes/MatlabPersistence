classdef DataMapper < handle
    
    properties(Access = private)
        persistenceUnit
        delegate
    end
    
    methods
        function obj = DataMapper(provider)
            obj.persistenceUnit = provider.persistenceUnit;
            obj.delegate = provider.delegate;
        end
        
        function entity = find(obj, entity)
            basics = obj.getBasics(entity);
            elementCollection = obj.getElementCollections(entity);
            entity = obj.delegate.getManager(obj, basics).find(entity);
            entity = obj.delegate.getManager(obj, elementCollection).find(entity);
        end
        
        function save(obj, entity)
            basics = obj.getBasics(entity);
            elementCollection = obj.getElementCollections(entity);
            obj.delegate.getManager(obj, basics).save(entity);
            obj.delegate.getManager(obj, elementCollection).save(entity);
        end
        
        function result = select(obj, query)
            result = obj.delegate.getQueryManager().execute(query);
        end
    end
    
    methods(Access = private)
        
        function b = getBasics(obj, entityInstance)
            clazz = class(entityInstance);
            e = obj.persistenceUnit.entityMap(clazz);
            b = e.basics;
        end
        
        function c = getElementCollections(obj, entityInstance)
            clazz = class(entityInstance);
            e = obj.persistenceUnit.entityMap(clazz);
            c = e.elementCollections;
        end
    end
end