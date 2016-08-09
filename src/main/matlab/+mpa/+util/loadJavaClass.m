function jClass = loadJavaClass(clazz)
try
    jClass = java.lang.Class.forName(clazz);
catch
    classLoader = com.mathworks.jmi.ClassLoaderManager.getClassLoaderManager;
    jClass = classLoader.loadClass(clazz);
end
end

