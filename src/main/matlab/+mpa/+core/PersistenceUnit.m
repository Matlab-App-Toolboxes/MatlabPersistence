classdef PersistenceUnit < handle
    
    properties(Access = private)
        jPersistenceUnit
    end
    
    properties(SetAccess = private)
        name
        entitySchemaMap
        propertyMap
        provider
        path
    end
    
    properties(Constant)
        ENTITY_MAPPING_CLASS = 'io.mpa.orm.schema.EntityMappings'
        ENTITIES = 'entities';
        PERSISTENCE_NAME = 'persistence-unit-name'
    end
    
    methods
        
        function obj = PersistenceUnit(jPersistence, name, path)
            import io.mpa.orm.util.*;
            obj.jPersistenceUnit = PersistenceFilter.getPersistenceUnit(jPersistence, name);
            obj.name = name;
            obj.path = path;
            obj.populateEntityMap();
            obj.populatePropertyMap();
            obj.createProvider();
        end
        
        function createProvider(obj)
            clazz = obj.jPersistenceUnit.getProvider();
            constructor = str2func(char(clazz));
            obj.provider = constructor();
            obj.provider.init(obj.propertyMap);
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
                
                obj.propertyMap(char(key)) = char(value);
            end
            obj.propertyMap(obj.ENTITIES) = obj.entitySchemaMap;
            obj.propertyMap(obj.PERSISTENCE_NAME) = obj.name;
        end
        
        function populateEntityMap(obj)
            obj.entitySchemaMap = containers.Map();
            ormPath = obj.jPersistenceUnit.getMappingFile().get(0);
           
            import io.mpa.orm.util.*;
            
            jClass = mpa.util.loadJavaClass(obj.ENTITY_MAPPING_CLASS);            
            ormPath = [fileparts(obj.path) filesep ormPath];
            jMappings = ComUtil.unMarshal(ormPath, jClass);
            jEntities = PersistenceFilter.getEntityMappings(jMappings.getEntity() , obj.jPersistenceUnit);
            
            jIterator = jEntities.iterator;
            
            while jIterator.hasNext()
                jEntity = jIterator.next();
                clazz = char(jEntity.getClazz());
                obj.entitySchemaMap(clazz) = mpa.core.metamodel.EntitySchema(jEntity);
            end
        end
    end
end
