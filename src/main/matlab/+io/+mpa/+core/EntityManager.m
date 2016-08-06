classdef EntityManager < handle
    
    properties(Access = private)
        provider
        persistenceUnit
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
        
        function result = execute(obj, queryString, entityClazz, varargin)
            dataManagerClazz = obj.getDataManager(entityInstance);
            result = obj.provider.delegate(dataManagerClazz).execute('query', queryString,...
                'clazz', entityClazz,...
                'entityManager', obj,...
                varargin);
        end
        
        function close(obj)
            obj.provider.close();
        end
    end
    
    methods(Access = private)
        
        function b = getBasics(obj, entityInstance)
            clazz = class(entityInstance);
            e = obj.persistenceUnit.entitySchemaMap(clazz);
            b = e.basics;
        end
        
        function dataManagerClazz = getDataManager(obj, entityInstance)
            clazz = class(entityInstance);
            e = obj.persistenceUnit.entitySchemaMap(clazz);
            dataManagerClazz = e.dataManager;
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
    end
    
    methods(Static)
        
        function obj = create(unitName, path)
            if nargin < 2
                path = which('persistence.xml');
            end
            persistent initializer;
            if isempty(initializer)
                initializer = io.mpa.core.Initializer(path);
            end
            unit = initializer.getPersistenceUnit(unitName);
            obj = io.mpa.core.EntityManager(unit);
        end
    end
end