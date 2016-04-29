function h5ex_g_phase
%**************************************************************************
%  This example shows how to set the conditions for
%  conversion between compact and dense (indexed) groups.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

FILE =        'h5ex_g_phase.h5';
MAX_GROUPS=  7;
MAX_COMPACT= 5;
MIN_DENSE=   3;


name='G0';                  % Name of subgroup %

%
% Set file access property list to allow the latest file format.
% This will allow the library to create new format groups.
%
fapl = H5P.create ('H5P_FILE_ACCESS');
H5P.set_libver_bounds (fapl, 'H5F_LIBVER_LATEST', 'H5F_LIBVER_LATEST');

%
% Create group access property list and set the phase change
% conditions.  In this example we lowered the conversion threshold
% to simplify the output, though this may not be optimal.
%
gcpl = H5P.create ('H5P_GROUP_CREATE');
H5P.set_link_phase_change (gcpl, MAX_COMPACT, MIN_DENSE);

%
% Create a new file using the default properties.
%
file = H5F.create (FILE, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', fapl);

%
% Create primary group.
%
group = H5G.create (file, name, 'H5P_DEFAULT', gcpl, 'H5P_DEFAULT');

%
% Add subgroups to 'group' one at a time, print the storage type
% for 'group' after each subgroup is created.
%
for i=1:MAX_GROUPS
    
    %
    % Define the subgroup name and create the subgroup.
    %
    name= [name(1), num2str(i)];
    subgroup = H5G.create (group, name, 'H5P_DEFAULT', ...
        'H5P_DEFAULT','H5P_DEFAULT');
    H5G.close (subgroup);
    
    %
    % Obtain the group info and print the group storage type
    %
    ginfo=H5G.get_info (group);
    fprintf([num2str(ginfo.nlinks) ' Group(s): Storage type is ']);
    
    switch ginfo.storage_type
        case H5ML.get_constant_value('H5G_STORAGE_TYPE_COMPACT')
            fprintf ('H5G_STORAGE_TYPE_COMPACT\n');
            % New compact format %
        case H5ML.get_constant_value('H5G_STORAGE_TYPE_DENSE')
            fprintf('H5G_STORAGE_TYPE_DENSE\n');
            % New dense (indexed) format %
        case H5ML.get_constant_value('H5G_STORAGE_TYPE_SYMBOL_TABLE')
            fprintf('H5G_STORAGE_TYPE_SYMBOL_TABLE\n');
            % Original format %
    end
end

disp(' ');

%
% Delete subgroups one at a time, print the storage type for
% 'group' after each subgroup is deleted.
%
for i=1:MAX_GROUPS
    
    %
    % Define the subgroup name and delete the subgroup.
    %
    name = [name(1), num2str(i)];
    H5L.delete (group, name, 'H5P_DEFAULT');
    
    %
    % Obtain the group info and print the group storage type
    %
    ginfo=H5G.get_info (group);
    fprintf([num2str(ginfo.nlinks) ' Group(s): Storage type is ']);
    switch ginfo.storage_type
        case H5ML.get_constant_value('H5G_STORAGE_TYPE_COMPACT')
            fprintf('H5G_STORAGE_TYPE_COMPACT\n');
            % New compact format %
        case H5ML.get_constant_value('H5G_STORAGE_TYPE_DENSE')
            fprintf('H5G_STORAGE_TYPE_DENSE\n');
            % New dense (indexed) format %
        case H5ML.get_constant_value('H5G_STORAGE_TYPE_SYMBOL_TABLE')
            fprintf('H5G_STORAGE_TYPE_SYMBOL_TABLE\n');
            % Original format %
    end
end

%
% Close and release resources.
%
H5P.close (fapl);
H5P.close (gcpl);
H5G.close (group);
H5F.close (file);




