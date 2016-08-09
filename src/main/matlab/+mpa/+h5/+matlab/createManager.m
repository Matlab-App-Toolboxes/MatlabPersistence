function manager = createManager(fname, types)
metaModel = class(types{1});

switch metaModel
    case 'mpa.core.metamodel.Basic'
        manager = mpa.h5.AttributeManager(fname, types);
    case 'mpa.core.metamodel.ElementCollection'
        manager = mpa.h5.DataSetManager(fname, types);
end
end
