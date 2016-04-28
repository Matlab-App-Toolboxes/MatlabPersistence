project_name = 'matlab-hdf5-persistence';

% dependecies from git (or) math exchange

dependecies(1).name = 'mmockito';
dependecies(1).url = 'https://github.com/ragavsathish/mmockito.git';
dependecies(1).scope = 'test';

dependecies(2).name = 'jsonlab';
dependecies(2).url = 'https://github.com/fangq/jsonlab.git';
dependecies(2).scope = 'dev';


addpath(genpath(pwd));
cp = getClassPath();
cd('lib')

pomPath = @(p) fullfile(cp.lib, p, 'pom.m');
deletePom = @(p) delete(pomPath(p));

% clone libraries if not exist and delete 'pom.m'

for i = 1:numel(dependecies)
    d = dependecies(i);
    
    if ~ exist(d.name, 'dir')
        git('clone', d.url);
        
        if exist(pomPath(d.name), 'file')
            deletePom(d.name);
        end
    end
end

% add new libraries to path
addpath(genpath(pwd));
cd(cp.root)

