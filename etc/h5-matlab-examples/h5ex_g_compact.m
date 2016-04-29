function h5ex_g_compact
%**************************************************************************
%  This example shows how to create 'compact-or-indexed'
%  format groups, new to 1.8.  This example also illustrates
%  the space savings of compact groups by creating 2 files
%  which are identical except for the group format, and
%  displaying the file size of each.  Both files have one
%  empty group in the root group.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

FILE1 =       'h5ex_g_compact1.h5';
FILE2 =       'h5ex_g_compact2.h5';
GROUP =       'G1';

%
%% Create file 1.  This file will use original format groups.
%
file = H5F.create (FILE1, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');
group = ...
    H5G.create (file, GROUP, 'H5P_DEFAULT', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Obtain the group info and print the group storage type.
%
ginfo=H5G.get_info (group);
disp (['Group storage type for ', FILE1]);
switch (ginfo.storage_type)
    case H5ML.get_constant_value('H5G_STORAGE_TYPE_COMPACT')
        disp ('is H5G_STORAGE_TYPE_COMPACT');
        % New compact format %
        
    case H5ML.get_constant_value('H5G_STORAGE_TYPE_DENSE')
        disp ('is H5G_STORAGE_TYPE_DENSE');
        % New dense (indexed) format %
        
    case H5ML.get_constant_value('H5G_STORAGE_TYPE_SYMBOL_TABLE')
        disp ('is H5G_STORAGE_TYPE_SYMBOL_TABLE');
        % Original format %
end

%
%% Close and re-open file.  Needed to get the correct file size.
%
H5G.close (group);
H5F.close (file);
file = H5F.open (FILE1, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');

%
% Obtain and print the file size.
%
fsize=H5F.get_filesize (file);
disp (['File size for ',FILE1,' is: ' num2str(fsize) ' bytes']);

%
% Close FILE1.
%
H5F.close (file);

%
% Set file access property list to allow the latest file format.
% This will allow the library to create new compact format groups.
%
fapl = H5P.create ('H5P_FILE_ACCESS');
H5P.set_libver_bounds (fapl, 'H5F_LIBVER_LATEST', 'H5F_LIBVER_LATEST');

%
% Create file 2 using the new file access property list.
%
file = H5F.create (FILE2, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', fapl );
group =...
    H5G.create (file, GROUP, 'H5P_DEFAULT', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Obtain the group info and print the group storage type.
%
ginfo=H5G.get_info (group);
disp (['Group storage type for ', FILE2]);
switch (ginfo.storage_type)
    case H5ML.get_constant_value('H5G_STORAGE_TYPE_COMPACT')
        disp ('is H5G_STORAGE_TYPE_COMPACT');
        % New compact format %
        
    case H5ML.get_constant_value('H5G_STORAGE_TYPE_DENSE')
        disp ('is H5G_STORAGE_TYPE_DENSE');
        % New dense (indexed) format %
        
    case H5ML.get_constant_value('H5G_STORAGE_TYPE_SYMBOL_TABLE')
        disp ('is H5G_STORAGE_TYPE_SYMBOL_TABLE');
        % Original format %
end

%
% Close and re-open file.  Needed to get the correct file size.
%
H5G.close (group);
H5F.close (file);
file = H5F.open (FILE2, 'H5F_ACC_RDONLY', fapl);

%
% Obtain and print the file size.
%
fsize=H5F.get_filesize (file);
disp (['File size for ',FILE2,' is: ',num2str(fsize),' bytes']);

%
% Close and release resources.
%
H5P.close (fapl);
H5F.close (file);

