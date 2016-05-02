function h5ex_g_create
%**************************************************************************
%
% This example shows how to create, open, and close a group.
%
% This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

FILE='h5ex_g_create.h5';

%
% Create a new file using the default properties.
%
file = H5F.create(FILE, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Create a group named "G1" in the file.
%
group = H5G.create(file, '/G1', 0);

%
% Close the group.  The handle "group" can no longer be used.
%
H5G.close (group);

%
% Re-open the group, obtaining a new handle.
%
group = H5G.open(file, '/G1');

%
% Close and release resources.
%
H5G.close(group);
H5F.close(file);

