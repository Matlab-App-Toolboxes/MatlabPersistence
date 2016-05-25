function obj = createEntityManager(id, h5properties)

if nargin < 2
        h5properties = which('h5properties.json');
    end

    json = loadjson(h5properties);
    fileProperties = json.location;

    for i = 1:numel(fileProperties)
        if strcmp(fileProperties{i}.id, id)
            fname = fileProperties{i}.local_path;
            persistence = fileProperties{i}.persistence;
            break;
        end
    end

    if isempty(fname)
        msgID = 'Invalid File';
        msg = 'Unable to find File present in h5properties.json';
        throw (MException(msgID, msg));
    end

    entites = enumeration(persistence);
    entityMap = containers.Map();
    
    for i = 1 :numel(entites.all)
        e = entites.all(i);
        entityMap(char(e)) = e;
    end
    obj = io.mpa.H5EntityManager(fname, entityMap);
end

