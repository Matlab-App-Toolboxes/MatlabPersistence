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
        
        function entity = find(obj, entity)
            basics = obj.getBasics(entity);
            elementCollection = obj.getElementCollections(entity);
            
            entity = obj.provider.delegate(basics).find(entity);
            entity = obj.provider.delegate(elementCollection).find(entity);
        end
        
        function persist(obj, entity)
            basics = obj.getBasics(entity);
            elementCollection = obj.getElementCollections(entity);
            entity.id = obj.getEntityId(entity);
            
            obj.provider.delegate(basics).save(entity);
            obj.provider.delegate(elementCollection).save(entity);
        end
        
        function query = createQuery(obj, queryString, entityClazz, varargin)
            dataManager = obj.getDataManager(entityClazz);
            dataManager.provider = obj.provider;
            query = dataManager.parse('query', queryString,...
                'clazz', entityClazz,...
                varargin);
        end
    end
    
    methods(Access = private)
        
        function b = getBasics(obj, entityInstance)
            clazz = class(entityInstance);
            e = obj.persistenceUnit.entitySchemaMap(clazz);
            b = e.basics;
        end
        
        function c = getElementCollections(obj, entityInstance)
            clazz = class(entityInstance);
            e = obj.persistenceUnit.entitySchemaMap(clazz);
            c = e.elementCollections;
        end
        
        function id = getEntityId(obj, entityInstance)
            clazz = class(entityInstance);
            entitySchema = obj.persistenceUnit.entitySchemaMap(clazz);
            id = entityInstance.(entitySchema.id);
            
            if isempty(entitySchema.id.converter)
                id = entitySchema.converter.convert(id);
            end
        end
        
        function delete(obj)
            obj.closeInitializer();
        end
    end
end