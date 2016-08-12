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
            
            if ~ isempty(basics)
                manager = obj.provider.getManager(basics);
                entity = manager.find(entity);
                manager.close();
            end
            
            if ~ isempty(elementCollection)
                manager = obj.provider.getManager(elementCollection);
                entity = manager.find(entity);
                manager.close();
            end
        end
        
        function persist(obj, entity)
            basics = obj.getBasics(entity);
            elementCollection = obj.getElementCollections(entity);
            entity = obj.prePersist(entity);
            
            if ~ isempty(basics)
                manager = obj.provider.getManager(basics);
                manager.save(entity);
                manager.close();
            end
            
            if ~ isempty(elementCollection)
                manager = obj.provider.getManager(elementCollection);
                manager.save(entity);
                manager.close();
            end
        end
        
        function merge(obj, entity)
            
        end
        
        function close(obj)
            obj.closeInitializer();
        end
    end
    
    methods(Access = private)
        
        function clazz = getClazz(obj, entityInstance)
            clazz = class(entityInstance);
            
            if isstruct(entityInstance)
                clazz = entityInstance.class;
            end
        end
        
        function b = getBasics(obj, entityInstance)
            clazz = obj.getClazz(entityInstance);
            e = obj.persistenceUnit.entitySchemaMap(clazz);
            b = e.basics;
        end
        
        function c = getElementCollections(obj, entityInstance)
            clazz = obj.getClazz(entityInstance);
            e = obj.persistenceUnit.entitySchemaMap(clazz);
            c = e.elementCollections;
        end
        
        function entityInstance = prePersist(obj, entityInstance)
            clazz = obj.getClazz(entityInstance);
            schema = obj.persistenceUnit.entitySchemaMap(clazz);
            
            if ~ isempty(schema.id.field)
                fieldInstance = mpa.fields.keyGenerator(entityInstance, schema.id.field);
                entityInstance.id = fieldInstance.key;
            end
        end
        
        function delete(obj)
            obj.closeInitializer();
        end
    end
end