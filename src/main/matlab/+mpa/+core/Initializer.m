classdef Initializer < handle
    
    properties(SetAccess = private)
        jPersistence
        persistencePath
    end
    
    properties(Access = private)
        context
    end
    
    properties(Constant)
        PERSISTENCE_CLASS = 'com.sun.java.xml.ns.persistence.Persistence'
    end
    
    methods
        
        function obj = Initializer(path)
            
            if isempty(path)
                error('persistence:not:found', 'Persistence xml not found');
            end
            
            obj.context = containers.Map();
            obj.persistencePath = path;
            obj.loadPersistence();
        end
        
        function unit = getPersistenceUnit(obj, name)
            
            if isKey(obj.context, name)
                unit = obj.context(name);
                return;
            end
            path = obj.persistencePath;
            unit = mpa.core.PersistenceUnit(obj.jPersistence, name, path);
            obj.context(name) = unit;
        end
    end
    
    methods(Access = private)
        
        function loadPersistence(obj)
            jClass = mpa.util.loadJavaClass(obj.PERSISTENCE_CLASS);
            import io.mpa.orm.util.*;
            obj.jPersistence = ComUtil.unMarshal(obj.persistencePath, jClass);
        end
    end
end