classdef PersistenceUnit < handle
    
    properties(Access = private)
        jPersistenceUnit
    end
    
    properties(SetAccess = private)
        name
        entitySchemaMap
        propertyMap
        provider
    end
    
    properties(Constant)
        ENTITY_MAPPING_CLASS = 'io.mpa.orm.schema.EntityMappings'
        PROVIDER = 'provider'
        ENTITIES = 'entities';
    end
    
    methods
        
        function obj = PersistenceUnit(jPersistence, name)
            obj.jPersistenceUnit = io.mpa.orm.util.PersistenceFilter.getPersistenceUnit(jPersistence, name);
            obj.name = name;
            obj.populateEntityMap();
            obj.populatePropertyMap();
            obj.createProvider();
        end
        
        function createProvider(obj)
            clazz = obj.propertyMap(obj.PROVIDER);
            constructor = str2func(clazz);
            obj.provider = constructor(obj.propertyMap);
        end
        
    end
    
    methods(Access = private)
        
        function populatePropertyMap(obj)
            obj.propertyMap = containers.Map();
            
            jIterator = obj.jPersistenceUnit.getProperties().getProperty().iterator;
            while jIterator.hasNext()
                jProperty = jIterator.next();
                key = jProperty.getName();
                value = jProperty.getValue();
                
                obj.propertyMap(key) = value;
            end
            obj.propertyMap(obj.ENTITIES) = obj.entitySchemaMap.keys;
        end
        
        function populateEntityMap(obj)
            obj.entitySchemaMap = containers.Map();
            
            path = obj.jPersistenceUnit.getMappingFile().get(0);
            import io.mpa.core.metaModel.*;
            import io.mpa.orm.util.*;
            
            jClass = java.lang.class.forName(obj.ENTITY_MAPPING_CLASS);
            jMappings = JAXBUtil.unMarshal(path, jClass);
            jEntities = PersistenceFilter.getEntityMappings(jMappings.getEntity() , obj.jPersistenceUnit);
            
            jIterator = jEntities.iterator;
            
            while jIterator.hasNext()
                jEntity = iterator.next();
                clazz = jEntity.getClazz();
                obj.entitySchemaMap(clazz) = EntitySchema(jEntity);
            end
        end
    end
end
