function javaaddpath()

% Add the following jars to matlab dyanamic path for easy execution
% 1) mpa-jutil-0.0.1-SNAPSHOT.jar   - provides marshalling and filtering support for persistence xml and orm xml
% 2) java-uuid-generator-3.1.4.jar  - provides way to generate unique id based on date-time

packageRoot = fileparts(mfilename('fullpath'));
rootPath = fileparts(fileparts(fileparts(fileparts(packageRoot))));
javaaddpath(fullfile(rootPath, 'lib', 'mpa-jutil-0.0.1-SNAPSHOT.jar'));
javaaddpath(fullfile(rootPath, 'lib', 'java-uuid-generator-3.1.4.jar'));
javaaddpath(fullfile(rootPath, 'lib', 'sqlite-jdbc-3.20.0.jar'));
end

