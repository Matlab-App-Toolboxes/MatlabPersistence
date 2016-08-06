function manager = createManager(fname, types)
metaModel = class(types{1});

switch metaModel
    case 'io.mpa.core.metamodel.Basic'
        manager = io.mpa.h5.AttributeManager(fname, types);
    case 'io.mpa.core.metamodel.ElementCollection'
        manager = io.mpa.h5.DataSetManager(fname, types);
    otherwise
        constructor = str2func(metaModel);
        manager = constructor(fname, types);
end
end
