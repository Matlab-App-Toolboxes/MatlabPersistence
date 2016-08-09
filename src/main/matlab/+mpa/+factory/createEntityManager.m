function obj = createEntityManager(unitName, path)
    if nargin < 2
        path = which('persistence.xml');
    end
    persistent initializer;
    if isempty(initializer)
        initializer = mpa.core.Initializer(path);
    end
    unit = initializer.getPersistenceUnit(unitName);
    obj = mpa.core.EntityManager(unit);
    obj.closeInitializer = @()destroy();
    
    function destroy()
        clear initializer;
    end
end