function cp = getClassPath()

    cp.root = fileparts(which('pom.m'));
    cp.src = fullfile(cp.root, 'src\main\matlab\');
    cp.resources =  fullfile(cp.root, 'src\main\resources\');
    cp.test_src = fullfile(cp.root, 'src\test\matlab\');
    cp.test_resources =  fullfile(cp.root, 'src\test\resources\');
    cp.lib = fullfile(cp.root, '\lib');

end

