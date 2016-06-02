classdef PersistenceCore < handle
    
    properties(SetAccess = private)
        path
        persistence
        entityMap
    end
    
    methods(Access = private)

        
        function ds = createDataSource(~, entities, properties)
            class = properties('dataSource');
            dataSource = str2func(class);
            ds = dataSource(entities, properties);
            
        end
    end
    
    methods
        
        function obj = PersistenceCore()
            obj.path = which('persistence.xml');
            
            import io.mpa.orm.util.*;
            persistencePath = java.lang.String(obj.path);
            class = com.sun.java.xml.ns.persistence.Persistence.class;
            obj.persistence = JAXBUtil.unMarshal(persistencePath, class);
            
            obj.entityMap = containers.Map();
        end
        
        function entities = getEntities(obj, unitName)
            import io.mpa.orm.util.*;
            
            if isKey(obj.entityMap, unitName)
               entities = obj.entityMap(unitName);
               return
            end
            name = java.lang.String(unitName);
            unit = PersistenceFilter.getPersistenceUnit(obj.persistence, name);
            
            mapping = unit.getMappingFile().get(0);
            ormPath = fullfile(obj.path, mapping);            
            ormPath = java.lang.String(ormPath);
            
            class = io.mpa.orm.schema.EntityMappings.class;
            entityList = JAXBUtil.unMarshal(ormPath, class).getEntity();
            entities = PersistenceFilter.getEntityMappings(entityList, unit);
            
            obj.entityMap(unitName) =  entities;
        end
        
        function properties = getPersistenceProperties(obj, unitName)
            
            import io.mpa.orm.util.*;
            name = java.lang.String(unitName);
            
            unit = PersistenceFilter.getPersistenceUnit(obj.persistence, name);
            properties = containers.Map();
            hashMap = io.mpa.orm.util.PersistenceUtil.getProperties(unit);
            hashKeys = hashMap.keys;
            
            while hashKeys.hasMoreElements()
                key = hashKeys.nextElement();
                properties(key) = hashMap.get(key);
            end
        end
    end
    
    methods(Static)
        
        function emf = getEntityManagerFactory(unitName)
            persistent f;
            
            if isempty(f)
                f =  io.mpa.infra.EntityManagerFactory(unitName);
            end
            emf = f;
        end
    end
end