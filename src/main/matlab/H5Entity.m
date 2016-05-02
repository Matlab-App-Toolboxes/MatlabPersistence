classdef H5Entity < handle
    
    properties(Abstract)
        identifier
        group
        schema
    end
    
    methods
        
        function insertSimpleAttributes(obj, entityManager)
        end
        
        function findSimpleAttributes(obj, entityManager)
        end

        function persist(obj, entityManager)
        end

        function find(obj, entityManager)
        end

        function get(obj, class)
        end
    end
end
