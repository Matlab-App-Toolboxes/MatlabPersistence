function h5ex_t_objrefatt
%**************************************************************************
%
%   This example shows how to read and write object references
%   to an attribute.  The program first creates objects in the
%   file and writes references to those objects to an
%   attribute with a dataspace of DIM0, then closes the file.
%   Next, it reopens the file, dereferences the references,
%   and outputs the names of their targets to the screen.
%
%   This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

fileName       = 'h5ex_t_objrefatt.h5';
DATASET        = 'DS1';
ATTRIBUTE      = 'AS1';
DIM0           = 2;

dims  =DIM0;

%
%% Create a new file using the default properties.
%
file = H5F.create (fileName, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Create a dataset with a scalar dataspace.
%
space = H5S.create ('H5S_SCALAR');
obj = H5D.create (file, 'DS2', 'H5T_STD_I32LE', space, 'H5P_DEFAULT');
H5D.close (obj);
H5S.close (space);

%
% Create a group.
%
size_hint=H5ML.get_constant_value('H5P_DEFAULT');
obj = H5G.create (file, 'G1', size_hint);
H5G.close (obj);

%
% Create references to the previously created objects.  Passing -1
% as space_id causes this parameter to be ignored.  Other values
% besides valid dataspaces result in an error.
%
wdata(:,1) = H5R.create (file, 'G1', 'H5R_OBJECT', -1);
wdata(:,2) = H5R.create (file, 'DS2', 'H5R_OBJECT', -1);

%
% Create dataset with a scalar dataspace to serve as the parent
% for the attribute.
%
space = H5S.create ('H5S_SCALAR');
dset  = H5D.create (file, DATASET, 'H5T_STD_I32LE', space, 'H5P_DEFAULT');
H5S.close (space);

%
% Create dataspace.  Setting maximum size to NULL sets the maximum
% size to be the current size.
%
space = H5S.create_simple (1, fliplr(dims), []);

%
% Create the attribute and write the object references to it.
%
attr = H5A.create (dset, ATTRIBUTE, 'H5T_STD_REF_OBJ', space, 'H5P_DEFAULT');
H5A.write (attr, 'H5T_STD_REF_OBJ', wdata);

%
% Close and release resources.
%
H5A.close (attr);
H5D.close (dset);
H5S.close (space);
H5F.close (file);

%
%% Now we begin the read section of this example.  Here we assume
% the attribute has the same name and rank, but can have any size.
%

%
% Open file dataset and attribute.
%
file = H5F.open (fileName, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
dset = H5D.open (file, DATASET);
attr = H5A.open_name(dset,ATTRIBUTE);

%
% Get dataspace.
%
space = H5A.get_space (attr);
[~, dims, ~] = H5S.get_simple_extent_dims (space);
dims = fliplr(dims);

%
% Read the data.
%
rdata = H5A.read (attr, 'H5T_STD_REF_OBJ');

%
% Output the data to the screen.
%
for i=1: dims(1)
    fprintf ('%s[%d]:\n  ->', ATTRIBUTE, i);
    %
    % Open the referenced object, get its name and type.
    %
    obj = H5R.dereference (dset, 'H5R_OBJECT', rdata(:,i));
    objtype = H5R.get_obj_type (dset, 'H5R_OBJECT', rdata(:,i));
    
    %
    % Retrieve the name.
    %
    name = H5I.get_name(obj);
    
    %
    % Print the object type and close the object.
    %
    switch (objtype)
        case H5ML.get_constant_value('H5G_GROUP')
            fprintf ('Group');
            H5G.close (obj);
        case H5ML.get_constant_value('H5G_DATASET')
            fprintf ('Dataset');
            H5D.close (obj);
        case H5ML.get_constant_value('H5G_TYPE')
            fprintf ('Named Datatype');
            H5T.close (obj);
    end
    
    %
    % Print the name
    %
    fprintf (': %s', name);
    
    fprintf ('\n');
end


%
% Close and release resources.
%
H5A.close (attr);
H5D.close (dset);
H5S.close (space);
H5F.close (file);

