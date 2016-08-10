classdef EntityManager < handle
    
    properties(Access = private)
        provider
        persistenceUnit
    end
    
    properties
        closeInitializer
    end
    
    methods
        function obj = EntityManager(unit)
            obj.provider = unit.provider;
            obj.persistenceUnit = unit;
        end
        
        function entity = find(obj, entity, key)
            basics = obj.getBasics(entity);
            elementCollection = obj.getElementCollections(entity);
            entity = obj.preFind(entity, key);
            
            if ~ isempty(basics)
                entity = obj.provider.delegate(basics).find(entity);
            end
            
            if ~ isempty(elementCollection)
                entity = obj.provider.delegate(elementCollection).find(entity);
            end
        end
        
        function persist(obj, entity)
            basics = obj.getBasics(entity);
            elementCollection = obj.getElementCollections(entity);
            entity = obj.prePersist(entity);
            
            if ~ isempty(basics)
                obj.provider.delegate(basics).save(entity);
            end
            
            if ~ isempty(elementCollection)
                obj.provider.delegate(elementCollection).save(entity);
            end
        end
        
        function query = createQuery(obj, queryString, entityClazz, varargin)
            dataManager = obj.getDataManager(entityClazz);
            dataManager.provider = obj.provider;
            query = dataManager.parse('query', queryString,...
                'clazz', entityClazz,...
                varargin);
        end
        
        function close(obj)
            obj.closeInitializer();
        end
    end
    
    methods(Access = private)
        
        function b = getBasics(obj, entityInstance)
            clazz = class(entityInstance);
            
            if isstruct(entityInstance)
                clazz = entityInstance.class;
            end
            e = obj.persistenceUnit.entitySchemaMap(clazz);
            b = e.basics;
        end
        
        function c = getElementCollections(obj, entityInstance)
            clazz = class(entityInstance);
            
            if isstruct(entityInstance)
                clazz = entityInstance.class;
            end
            e = obj.persistenceUnit.entitySchemaMap(clazz);
            c = e.elementCollections;
        end
        
        function entityInstance = prePersist(obj, entityInstance)
            
            clazz = mpa.core.metamodel.EntitySchema.getClazz(entityInstance);
            schema = obj.persistenceUnit.entitySchemaMap(clazz);
            
            if ~ isempty(schema.id.converter)
                key = schema.id.converter.prePersist(entityInstance);
            end
            entityInstance.id = key;
        end
        
        function entityInstance = preFind(obj, entityInstance, key)
            clazz = mpa.core.metamodel.EntitySchema.getClazz(entityInstance);
            schema = obj.persistenceUnit.entitySchemaMap(clazz);
            
            if ~ isempty(schema.id.converter)
                key = schema.id.converter.preFind(entityInstance, key);
            end
            entityInstance.id = key;
        end
        
        function delete(obj)
            obj.closeInitializer();
        end
    end
end