classdef DateTimeConverter < mpa.util.Converter
    
    properties
        metaModel
    end
    
    methods
        
        function obj = DateTimeConverter(metaModel)
            obj.metaModel = metaModel;
        end
        
        function result = convert(obj, entity, time)
            
            if nargin < 3
                time = now;
            end
            prefix = matlab.lang.makeValidName(class(entity));
            value = entity.(obj.metaModel.name);
            date = strrep(datestr(time), ':', '_');
            date = strrep(date, ' ', '_');
            result = [prefix '_' value '_' date];
        end
    end
end