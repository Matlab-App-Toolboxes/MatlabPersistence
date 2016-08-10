function manager = createManager(fname, types)
metaModel = class(types(1));

switch metaModel
    case 'mpa.core.metamodel.Basic'
        manager = mpa.h5.matlab.AttributeManager(fname, types);
    case 'mpa.core.metamodel.ElementCollection'
        manager = mpa.h5.matlab.DataSetManager(fname, types);
end
end
