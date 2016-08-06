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
            
            obj.context = containers.Map();
            obj.persistencePath = path;
            obj.loadPersistence();
        end
        
        function unit = getPersistenceUnit(obj, name)
            
            if iskey(obj.context, name)
                unit = obj.context(name);
                return;
            end
            unit = io.mpa.orm.PersistenceUnit(obj.jPersistence, name);
            obj.context(name) = unit;
        end
    end
    
    methods(Access = private)
        
        function loadPersistence(obj)
            
            import io.mpa.orm.util.*;
            jClass = java.lang.class.forName(obj.PERSISTENCE_CLASS);
            obj.jPersistence = JAXBUtil.unMarshal(obj.persistencePath, jClass);
        end
    end
end