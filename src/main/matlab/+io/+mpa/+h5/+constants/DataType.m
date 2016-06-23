classdef DataType < handle

    enumeration
        DOUBLE('H5T_NATIVE_DOUBLE')
        INT('H5T_NATIVE_INT')
        STRING('H5T_C_S1')
    end
    
    properties
        name
    end
    
    methods
        
        function obj = DataType(name)
            obj.name = name;
        end
        
        function size = getSize(obj)
            import io.mpa.h5.constants.*;
            t = H5T.copy(obj.name);
            
            if ismember(obj, DataType.STRING)
                H5T.set_size (t, 'H5T_VARIABLE');
            end
            size = H5T.get_size(t);
        end
    end
end

