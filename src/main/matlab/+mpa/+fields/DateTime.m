classdef DateTime < handle
    
    properties
        key
        uuid
        time
    end
    
    properties(Constant)
        DATE_FORMAT = 'MM/dd/yyyy HH:mm:ss';
    end
    
    methods
        
        function obj = DateTime(key)
            obj.key = key;
        end
        
        function uuid = get.uuid(obj)
            
            cell = strsplit(obj.key, '/');
            id = char(cell(end));
            idx = strfind(id, '-');
            uuid = id(idx(1) + 1 : end);
        end
        
        function time = get.time(obj)
            
            format = obj.DATE_FORMAT;
            
            jDate = io.mpa.orm.util.ComUtil.getDateFromUUID(obj.uuid);
            dateFormatter = java.text.SimpleDateFormat(format);
            dateString = char(dateFormatter.format(jDate));
            
            time = datetime(dateString, 'InputFormat', format);
        end
    end
    
    methods(Static)
        
        function dateTimeId = generate(entity, name)
            
            uuid = com.fasterxml.uuid.Generators.timeBasedGenerator().generate();
            uuid = char(uuid.toString());
            
            clazz = mpa.util.getClazz(entity);
            prefix = matlab.lang.makeValidName(clazz);
            value = entity.(name);
            
            if isempty(value)
                value = 'id';
            end
            value = matlab.lang.makeValidName(value);
            key = ['/' prefix '/' value '-' uuid];
            dateTimeId = mpa.fields.DateTime(key);
        end
    end
    
end

