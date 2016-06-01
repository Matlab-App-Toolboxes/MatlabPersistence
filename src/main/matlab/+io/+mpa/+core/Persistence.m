classdef Persistence < handle
    
    properties(SetAccess = private)
        persistence
        path
        persistenceContext
    end
   
    methods(Access = private)

        function map = getPersistenceProperties(~, unit)
            map = containers.Map();
            hashMap = io.mpa.orm.util.PersistenceUtil.getProperties(unit);
            hashKeys = hashMap.keys; 
           
            while hashKeys.hasMoreElements()
                key = hashKeys.nextElement();
                map(key) = hashMap.get(key);
            end
        end

        function ds = createDataSource(~, entities, properties)
            class = properties('dataSource');
            dataSource = str2func(class);
            ds = dataSource(entities, properties);
        end
    end

    methods

        function obj = Persistence()
            obj.path = which('persistence.xml');
            obj.persistenceContext = io.mpa.infra.PersistenceContext();
            
            import io.mpa.orm.util.*;
            persistencePath = java.lang.String(obj.path);
            class = com.sun.java.xml.ns.persistence.Persistence.class;
            obj.persistence = JAXBUtil.unMarshal(persistencePath, class);
            
        end
        
        function addIfNotExist(obj, unitName)
            
            if obj.persistenceContext.has(unitName)
                return;
            end

            import io.mpa.orm.util.*;
            name = java.lang.String(unitName);
            unit = PersistenceFilter.getPersistenceUnit(obj.persistence, name);
            
            mapping = unit.getMappingFile().get(0);
            ormPath = fullfile(obj.path, mapping);
            
            ormPath = java.lang.String(ormPath);
            class = io.mpa.orm.schema.EntityMappings.class;
            entityList = JAXBUtil.unMarshal(ormPath, class).getEntity();
            entities = PersistenceFilter.getEntityMappings(entityList, unit);

            properties = obj.getPersistenceProperties(unit);
            dataSource = obj.createDataSource(entities, properties);
            
            obj.persistenceContext.add(unitName, dataSource);
        end
    end
    
    methods(Static)
        
        function emf = getEntityManagerFactory(unitName)
            persistent f;
            
            if isempty(f)
                p = io.mpa.core.Persistence();
                p.addIfNotExist(unitName);
                f =  io.mpa.infra.EntityManagerFactory(p.persistenceContext);
            end
            f.persistenceCore.addIfNotExist(unitName);
            emf = f;
        end
    end
end