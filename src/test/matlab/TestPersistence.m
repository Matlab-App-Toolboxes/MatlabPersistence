classdef TestPersistence
    
    enumeration
        ENTITIES([...
            TestSchema.COMPUND_ENTITY_DS,...
            TestSchema.COMPUND_ENTITY_ATTR,...
            TestSchema.SIMPLE_ENTITY_ATTR,...
            TestSchema.COMPLEX_ENTITY,...
            ])
    end
    
    properties
        all
    end
    
    methods
        function obj = TestPersistence(entites)
            obj.all = entites;
        end
    end
end

