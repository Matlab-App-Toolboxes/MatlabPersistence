function h5ex_g_intermediate
%**************************************************************************
%  This example shows how to create intermediate groups with
%  a single call to H5G.create.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

FILE =         'h5ex_g_intermediate.h5';

DATASET        = 'DS1';
DIM0           = 4;
DIM1           = 7;

dims = [DIM0 DIM1];
wdata= zeros(dims);

%
% Initialize data.
%
for i=1: DIM0
    for j=1: DIM1
        ii=i-1;
        jj=j-1;
        wdata(i,j) =  ii / (jj + 0.5) + jj;
    end
end


%
%% Create a new file using the default properties.
%
file = H5F.create (FILE, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Create group creation property list and set it to allow creation
% of intermediate groups.
%
gcpl = H5P.create ('H5P_LINK_CREATE');
H5P.set_create_intermediate_group (gcpl, 1);

%
% Create the group /G1/G2/G3.  Note that /G1 and /G1/G2 do not
% exist yet.  This call would cause an error if we did not use the
% previously created property list.
%
group = H5G.create (file, '/G1/G2/G3', gcpl,'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Create dataspace.  Setting maximum size to [] sets the maximum
% size to be the current size.
%
space = H5S.create_simple (2,fliplr( dims), []);

%
% Create the dataset and write the floating podata to it.  In
% this example we will save the data as 64 bit little endian IEEE
% floating ponumbers, regardless of the native type.  The HDF5
% library automatically converts between different floating point
% types.
%
dset = H5D.create (file, DATASET, 'H5T_IEEE_F64LE', space, 'H5P_DEFAULT');
H5D.write (dset, 'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT',wdata);


%
% Print all the objects in the files to show that intermediate
% groups have been created.
%
disp ('Objects in the file:');
H5O.visit (file, 'H5_INDEX_NAME', 'H5_ITER_NATIVE', @op_func, []);

%
% Close and release resources.
%
H5P.close (gcpl);
H5G.close (group);
H5F.close (file);


end

function [status opdataOut]=op_func(rootId,name,opdataIn)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Operator function for H5O.visit.  This function prints the
%name and type of the object passed to it.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf ('/');               % Print root group in object path %

objId=H5O.open(rootId,name,'H5P_DEFAULT');
type=H5I.get_type(objId);
H5O.close(objId);

%
% Check if the current object is the root group, and if not print
% the full path name and type.
%
if (~(name == '.'))         % Root group, do not print '.' %
    
    switch (type)
        case H5ML.get_constant_value('H5I_GROUP')
            disp ([name ' (Group)']);
        case H5ML.get_constant_value('H5I_DATASET')
            disp ([name ' (Dataset)']);
        case H5ML.get_constant_value('H5I_DATATYPE')
            disp ([name ' (Datatype)']);
        otherwise
            disp ([name ' (Unknown)']);
    end
    
    
end
status=0;
opdataOut=opdataIn;
end
