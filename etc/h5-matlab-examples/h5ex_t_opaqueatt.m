function h5ex_t_opaqueatt
%**************************************************************************
%
%  This example shows how to read and write opaque datatypes
%  to an attribute.  The program first writes opaque data to
%  an attribute with a dataspace of DIM0, then closes the
%  file. Next, it reopens the file, reads back the data, and
%  outputs it to the screen.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

fileName       = 'h5ex_t_opaqueatt.h5';
DATASET        = 'DS1';
ATTRIBUTE      = 'A1';
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
% Create dataset with a scalar dataspace.
%
space = H5S.create ('H5S_SCALAR');
dset = H5D.create (file, DATASET, 'H5T_STD_I32LE', space, 'H5P_DEFAULT');
H5S.close (space);

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
% Create the attribute and write the opaque data to it.
%
attr = H5A.create (dset, ATTRIBUTE, dtype, space, 'H5P_DEFAULT');
H5A.write (attr, dtype, wdata);

%
% Close and release resources.
%
H5A.close (attr);
H5D.close (dset);
H5S.close (space);
H5T.close (dtype);
H5F.close (file);

%
%% Now we begin the read section of this example.  Here we assume
% the attribute has the same name and rank, but can have any size.
%

%
% Open file, dataset, and attribute.
%
file = H5F.open (fileName, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
dset = H5D.open (file, DATASET);
attr = H5A.open_name (dset, ATTRIBUTE);

%
% Get datatype and properties for the datatype.
%
dtype = H5A.get_type (attr);
%len   = H5T.get_size (dtype);
tag   = H5T.get_tag (dtype);

%
% Get dataspace
%
space = H5A.get_space (attr);
[~, dims, ~] = H5S.get_simple_extent_dims (space);
dims=fliplr(dims);

%
% Read the data.
%
rdata = H5A.read (attr, dtype);

%
% Output the data to the screen.
%
fprintf ('Datatype tag for %s is: "%s"\n', DATASET, tag);
for i=1: dims(1)
    fprintf ('%s[%u]: ', ATTRIBUTE, i);
    fprintf ('%s',char(rdata(:,i)));
    fprintf ('\n');
end

%
% Close and release resources.
%
H5A.close (attr);
H5D.close (dset);
H5S.close (space);
H5T.close (dtype);
H5F.close (file);

