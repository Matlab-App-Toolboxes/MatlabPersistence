function clazz = getClazz(entityInstance)
clazz = class(entityInstance);

if isstruct(entityInstance)
    clazz = entityInstance.class;
end
end