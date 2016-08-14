classdef H5Manager < handle
    
    properties
        attributeManager
        dataSetManager
        entityMap
        hasCollections
        hasBasics
    end
    
    properties
        closeInitializer
    end
    
    methods
        
        function obj = H5Manager(fname, entityMap)
            obj.attributeManager = mpa.h5.matlab.AttributeManager(fname);
            obj.dataSetManager = mpa.h5.matlab.DataSetManager(fname);
            obj.entityMap = entityMap;
        end
        
        function init(obj, entity)
            clazz = mpa.util.getClazz(entity);
            schema = obj.entityMap(clazz);
            
            obj.hasCollections = ~ isempty(schema.elementCollections);
            obj.hasBasics = ~ isempty(schema.basics);
            
            if obj.hasBasics
                obj.attributeManager.init(schema);
            end
            
            if obj.hasCollections
                obj.dataSetManager.init(schema);
            end
        end
        
        function entity = find(obj, entity)
            obj.init(entity)
            
            if obj.hasBasics
                entity = obj.attributeManager.find(entity);
            end
            
            if obj.hasCollections
                entity = obj.dataSetManager.find(entity);
            end
            obj.clear(entity);
        end
        
        function entity = prePersist(obj, entity)
            clazz = mpa.util.getClazz(entity);
            schema = obj.entityMap(clazz);
            
            if ~ isempty(schema.id.field)
                fieldInstance = mpa.fields.keyGenerator(entity, schema.id.field);
                entity.id = fieldInstance.key;
            end
        end
        
        
        function persist(obj, entity)
            obj.init(entity);
            entity = obj.prePersist(entity);
            
            if obj.hasBasics
                entity = obj.attributeManager.save(entity);
            end
            if obj.hasCollections
                entity = obj.dataSetManager.save(entity);
            end
            
            obj.clear(entity);
        end
        
        function clear(obj, entity)
            obj.attributeManager.close(entity);
            obj.dataSetManager.close(entity);
        end
        
        function close(obj)
            obj.closeInitializer();
        end
        
        function delete(obj)
            obj.close();
        end
        
    end
    
end

