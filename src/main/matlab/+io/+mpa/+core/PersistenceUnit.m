classdef PersistenceUnit < handle
    
    properties(Access = private)
        jPersistenceUnit
    end
    
    properties(SetAccess = private)
        name
        entityMap
        propertyMap
    end
    
    properties(Constant)
        ENTITY_MAPPING_CLASS = 'io.mpa.orm.schema.EntityMappings'
    end
    
    methods
        
        function obj = PersistenceUnit(jPersistence, name)
            obj.jPersistenceUnit = io.mpa.orm.util.PersistenceFilter.getPersistenceUnit(jPersistence, name);
            obj.name = name;
            obj.populateEntityMap();
            obj.populatePropertyMap();
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
        end
        
        function populateEntityMap(obj)
            obj.entityMap = containers.Map();
            
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
                obj.entityMap(clazz) = Entity(jEntity);
            end
        end
    end
end
