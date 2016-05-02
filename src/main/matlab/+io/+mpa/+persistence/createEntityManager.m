function obj = createEntityManager(id, h5properties)

    cp = getClassPath();
    if nargin < 2
        h5properties = [cp.resources 'h5properties.json'];
    end

    json = loadjson(h5properties);
    fileProperties = json.location;
    persistenceClass = json.persistence;

    [entity, description] = enumeration(persistenceClass);
    entityMap = containers.Map();
    for i = 1 :numel(entity)
        entityMap(description{i}) = entity;
    end

    obj = io.mpa.EntityManagerFactory(fileProperties, persistenceClass).create(id, entityMap);
end

