classdef PersistenceCore < handle
    
    properties(Access = private)
        persistence
        path
        persistenceContext
    end
   
    methods(Access = private)

        function map = getPersistenceProperties(obj, unitName)
            map = containers.Map();
            hashMap = io.mpa.orm.util.PersistenceUtil.getProperties(obj.persistenceUnit);
            hashKeys = hashMap.keys; 
           
            while hashKeys.hasMoreElements()
                key = hashKeys.nextElement();
                map(key) = hashMap.get(key);
            end
        end

        function ds = createDataSource(obj, entities, properties)
            class = persistenceUnit.properties('dataSource');
            dataSource = str2func(class)
            ds = dataSource(entities, properties);
        end
    end

    methods

        function obj = PersistenceCore()
            obj.path = which('persistenceContext    .xml');
            obj.persistenceContext = containers.Map();
            
            import io.mpa.orm.util.*;
            persistencePath = java.lang.String(obj.path);
            class = com.sun.java.xml.ns.persistence.Persistence.class;
            obj.persistence = JAXBUtil.unMarshal(persistencePath, class);
            
        end
        
        function addIfNotExist(obj, unitName)
            
            if isKey(obj.persistenceContext, unitName)
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
            

            properties = obj.getPersistenceProperties(unitName);
            dataSource = obj.createDataSource(entities, properties);
            
            obj.persistenceContext(unitName) = dataSource;
        end


        function ds = getDataSource(obj, unitName)
            ds = obj.persistenceContext(unitName);
        end
    end
    
    methods(Static)
        
        function emf = getEntityManagerFactory(unitName)
            persistent f;
            
            if isempty(f)
                p = io.mpa.PersistenceCore();
                p.addIfNotExist(unitName);
                f =  io.mpa.EntityManagerFactory(p);
            end
            f.persistenceCore.addIfNotExist(unitName);
            emf = f;
        end
    end
end