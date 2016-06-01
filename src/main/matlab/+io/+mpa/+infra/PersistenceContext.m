classdef PersistenceContext < handle;
    
    properties
        map
    end
    
    properties(Constant)
        ENTITY_MANAGER = 'em'
        DATA_SOURCE = 'ds'
    end
    
    methods
        function obj = PersistenceContext()
            obj.map = containers.Map();
        end
        
        function addDataSource(obj, id, ref)
            key = strcat(obj.ENTITY_MANAGER, id);
            obj.map(key) = ref;
        end
        
        function addEntityManager(obj, id, ref)
            key = strcat(obj.ENTITY_MANAGER, id);
            obj.map(key) = ref;
        end
        
        function ds = getDataSource(obj, id)
            key = strcat(obj.DATA_SOURCE_PREFIX, id);
            ds = obj.map(key);
        end
        
        function em = getEntityManager(obj, id)
            key = strcat(obj.ENTITY_MANAGER, id);
            em = obj.map(key);
        end
        
        function tf = hasDataSource(obj, id)
            tf = isKeys(obj.map, strcat(obj.DATA_SOURCE, id));
        end
        
        function tf = hasEntityManager(obj, id)
            tf = isKeys(obj.map, strcat(obj.ENTITY_MANAGER, id));
        end
        
        function remove(obj, id, type)
            key = strcat(type, id);
            ref = obj.map(key);
            remove(obj.map, key);
            delete(ref);
        end
    end
end