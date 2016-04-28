project_name = 'matlab-simple-archetype';

addpath(genpath(pwd));
cp = getClassPath();

% dependecies from git (or) math exchange
cd(cp.lib)

% Test dependency
if ~ exist('mmockito', 'dir')
    git clone 'https://github.com/ragavsathish/mmockito.git'
end

cd(cp.root)

