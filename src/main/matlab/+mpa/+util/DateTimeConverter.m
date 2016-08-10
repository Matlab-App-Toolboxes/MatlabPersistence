classdef DateTimeConverter < mpa.util.Converter
    
    properties
        metaModel
    end
    
    methods
        
        function obj = DateTimeConverter(metaModel)
            obj.metaModel = metaModel;
        end
        
        function result = prePersist(obj, entity)
            result = obj.convert(entity);
        end
        
        function result = preFind(obj, entity, key)
            result = obj.convert(entity, key);
        end
    end
    
    methods(Access = private)
        
        function result = convert(obj, entity, time)
            
            if nargin < 3
                time = now;
            end
            clazz = mpa.core.metamodel.EntitySchema.getClazz(entity);
            prefix = matlab.lang.makeValidName(clazz);
            value = entity.(obj.metaModel.name);
            date = strrep(datestr(time), ':', '_');
            date = strrep(date, ' ', '_');
            result = ['/' prefix '/' value '_' date];
        end
    end
    
    methods(Static)
        
        function time = keyToDateTime(key)
            cell = strsplit(key, '/');
            id = char(cell(end));
            idx = strfind(id, '_');
            
            date = id(idx(1) + 1 : end);
            time = datetime(datestr(datenum(date, 'dd-mmm-yyyy_HH_MM_SS')));
        end
    end
end