classdef PersistenceCore < handle
    
    properties
        persistence
        path
        persistenceContext
    end
    
    methods
        function obj = PersistenceCore()
            obj.path = which('persistence.xml');
            obj.persistenceContext = containers.Map();
            
            import io.mpa.orm.util.*;
            persistencePath = java.lang.String(obj.path);
            class = com.sun.java.xml.ns.persistence.Persistence.class;
            obj.persistence = JAXBUtil.unMarshal(persistencePath, class);
            
        end
        
        function unit = getPersistenceUnit(obj, unitName)
            name = java.lang.String(unitName);
            unit = io.mpa.orm.util.PersistenceFilter.getPersistenceUnit(obj.persistence, name);
        end
        
        function loadEntityMappings(obj, unitName)
            
            unit = obj.getPersistenceUnit(unitName);
            mapping = unit.getMappingFile().get(0);
            ormPath = fullfile(obj.path, mapping);
            
            import io.mpa.orm.util.*;
            ormPath = java.lang.String(ormPath);
            class = io.mpa.orm.schema.EntityMappings.class;
            entityList = JAXBUtil.unMarshal(ormPath, class).getEntity();
            entities = PersistenceFilter.getEntityMappings(entityList, unit);
            obj.persistenceContext(name) = entities;
        end
    end
    
    methods(Static)
        
        function emf = getEntityManagerFactory(unitName)
            persistent factory;
            
            if isempty(factory)
                p = io.mpa.PersistenceCore();
                p.loadEntityMappings(unitName);
                
                factory =  io.mpa.EntityManagerFactory(p);
            elseif ~ factory.hasPersistence(unitName)
                factory.persistenceCore.add    
            end
            emf = factory;
        end
    end
end