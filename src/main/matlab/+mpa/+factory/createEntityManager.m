function obj = createEntityManager(unitName, path)

if nargin < 2
    path = which('persistence.xml');
end

persistent initializer;
try
    if isempty(initializer)
        initializer = mpa.core.Initializer(path);
    end
    obj = initializer.getPersistenceUnit(unitName).createProvider().createEntityManager();
catch exception
    destroy();
    rethrow(exception);
end

    function destroy()
        delete(initializer);
        initializer = [];
    end
end