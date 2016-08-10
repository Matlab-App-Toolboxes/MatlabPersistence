classdef Converter < handle
    
    methods(Abstract)
        preFind(obj, entity, key)
        prePersist(obj, entity)
    end
end

