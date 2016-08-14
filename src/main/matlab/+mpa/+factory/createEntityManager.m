function obj = createEntityManager(unitName, path)

if nargin < 2
    path = which('persistence.xml');
end

persistent initializer;
try
    if isempty(initializer)
        initializer = mpa.core.Initializer(path);
    end
    unit = initializer.getPersistenceUnit(unitName);
    obj = unit.provider.createEntityManager();
    obj.closeInitializer = @()destroy();
catch exception
    destroy();
    rethrow(exception);
end

    function destroy()
        clear initializer;
    end
end