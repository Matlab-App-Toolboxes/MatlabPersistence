function h5ex_t_opaque
%**************************************************************************
%
%  This example shows how to read and write opaque datatypes
%  to a dataset.  The program first writes opaque data to a
%  dataset with a dataspace of DIM0, then closes the file.
%  Next, it reopens the file, reads back the data, and
%  outputs it to the screen.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

fileName       = 'h5ex_t_opaque.h5';
DATASET        = 'DS1';
DIM0           = 4;
LEN            = 7;

dims  =DIM0;
wdata =uint8(zeros(LEN,DIM0));
str   ='OPAQUE';

%
% Initialize data.
%
for i=1: DIM0
    wdata(:,i)=[str,num2str(i)];
end

%
%% Create a new file using the default properties.
%
file = H5F.create (fileName, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Create opaque datatype and set the tag to something appropriate.
% For this example we will write and view the data as a character
% array.
%
dtype = H5T.create ('H5T_OPAQUE', LEN);
H5T.set_tag (dtype, 'Character array');

%
% Create dataspace.  Setting maximum size to [] sets the maximum
% size to be the current size.
%
space = H5S.create_simple (1,fliplr( dims), []);

%
% Create the dataset and write the opaque data to it.
%
dset = H5D.create (file, DATASET, dtype, space, 'H5P_DEFAULT');
H5D.write (dset, dtype, 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT', wdata);

%
% Close and release resources.
%
H5D.close (dset);
H5S.close (space);
H5T.close (dtype);
H5F.close (file);

%
%% Now we begin the read section of this example.  Here we assume
% the dataset has the same name and rank, but can have any size.
%

%
% Open file and dataset.
%
file = H5F.open (fileName, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
dset = H5D.open (file, DATASET);

%
% Get datatype and properties for the datatype.
%
dtype = H5D.get_type (dset);
%len   = H5T.get_size (dtype);
tag   = H5T.get_tag (dtype);

%
% Get dataspace
%
space = H5D.get_space (dset);
[~, dims, ~] = H5S.get_simple_extent_dims (space);
dims=fliplr(dims);

%
% Read the data.
%
rdata = H5D.read (dset, dtype, 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');

%
% Output the data to the screen.
%
fprintf ('Datatype tag for %s is: "%s"\n', DATASET, tag);
for i=1: dims(1)
    fprintf ('%s[%u]: ', DATASET, i);
    fprintf ('%s',char(rdata(:,i)));
    fprintf ('\n');
end

%
% Close and release resources.
%
H5D.close (dset);
H5S.close (space);
H5T.close (dtype);
H5F.close (file);

