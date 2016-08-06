classdef H5GenericDataManager < handle
    
    properties
        fname
        description
    end
    
    properties(Constant)
        NAMED_QUERY_FIND_ALL_BY_CREATION_DATE = 'findByCreationDate'
        NAMED_QUERY_FIND_LATEST_BY_CREATION_DATE = 'findLatestByCreationDate'
    end
    
    methods
        
        function obj = H5GenericDataManager(fname, entityDescription)
            obj.fname = fname;
            obj.description = entityDescription;
        end
        
        function result = execute(obj, varargin)
            ip = inputParser;
            ip.KeepUnmatched = true;
            ip.addParameter('Query', '', @(x)ischar(x));
            ip.addParameter('Clazz', 'cell', @(x)ischar(x));
            ip.parse(varargin{:});
            
            fun = str2func(['@(obj, clazz)' ip.results.Query '(obj, clazz)']);
            result = fun(obj, ip.results.Clazz);
        end
        
        function findByCreationDate(obj, clazz)
            info = h5info(obj.fname, obj.description);
            start = size(obj.description) + 1;
            id = arrayfun(@(g) g.Name(start : end), info.Groups, 'UniformOutput', false);
        end
    end
    
end

