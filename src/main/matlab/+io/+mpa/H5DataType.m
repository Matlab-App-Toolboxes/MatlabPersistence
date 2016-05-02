classdef H5DataType < handle
    
    enumeration
        COMPOUND_INTEGER_DATASET(@()H5T.copy('H5T_NATIVE_INT'), io.mpa.H5DataClass.COMPOUND_DS)
        COMPOUND_STRING_DATASET(@()H5T.copy ('H5T_C_S1'), io.mpa.H5DataClass.COMPOUND_DS)
        COMPOUND_DOUBLE_DATASET(@()H5T.copy('H5T_NATIVE_DOUBLE'), io.mpa.H5DataClass.COMPOUND_DS)
        
        COMPOUND_INTEGER_ATTR(@()H5T.copy('H5T_NATIVE_INT'),  io.mpa.H5DataClass.COMPOUND_ATTR)
        COMPOUND_STRING_ATTR(@()H5T.copy ('H5T_C_S1'), io.mpa.H5DataClass.COMPOUND_ATTR)
        COMPOUND_DOUBLE_ATTR(@()H5T.copy('H5T_NATIVE_DOUBLE'), io.mpa.H5DataClass.COMPOUND_ATTR)
        
        SIMPLE_INTEGER_ATTR([], io.mpa.H5DataClass.SIMPLE_ATTR)
        SIMPLE_STRING_ATTR([],  io.mpa.H5DataClass.SIMPLE_ATTR)
        SIMPLE_DOUBLE_ATTR([],  io.mpa.H5DataClass.SIMPLE_ATTR)
    end
    
    properties
        type
        class
        copyHandle
    end
    
    methods
        
        function obj = H5DataType(copyHandle, class)
            obj.copyHandle = copyHandle;
            obj.class = class;
        end
        
        function sz = getSize(obj)
            import io.mpa.*;
            
            if obj.class == H5DataClass.SIMPLE_ATTR
                sz = [];
                return;
            end
            
            obj.type = obj.copyHandle();
            
            if ismember(obj, [H5DataType.COMPOUND_STRING_DATASET H5DataType.COMPOUND_STRING_ATTR])
                H5T.set_size (obj.type, 'H5T_VARIABLE');
            end
            sz= H5T.get_size(obj.type);
        end
        
        function str = map(obj, property)
            str = ['"' property '" : "' char(obj) '" ,'];
        end
    end
end