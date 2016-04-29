function h5ex_t_floatatt
%**************************************************************************
%
% This example shows how to read and write floating point
% datatypes to an attribute.  The program first writes
% floating ponumbers to an attribute with a dataspace of
% DIM0xDIM1, then closes the file.  Next, it reopens the
% file, reads back the data, and outputs it to the screen.
%
% This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

fileName       = 'h5ex_t_floatatt.h5';
DATASET        = 'DS1';
ATTRIBUTE      = 'A1';
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
file = H5F.create (fileName, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Create dataset with a scalar dataspace.
%
space = H5S.create ('H5S_SCALAR');
dset = H5D.create (file, DATASET, 'H5T_STD_I32LE', space, 'H5P_DEFAULT');
H5S.close (space);

%
% Create dataspace.  Setting maximum size to [] sets the maximum
% size to be the current size.
%
space = H5S.create_simple (2,fliplr( dims), []);

%
% Create the attribute and write the floating point data to it.
% In this example we will save the data as 64 bit little endian
% IEEE floating point numbers, regardless of the native type.  The
% HDF5 library automatically converts between different floating
% point types.
%
attr = H5A.create (dset, ATTRIBUTE, 'H5T_IEEE_F64LE', space, 'H5P_DEFAULT');
H5A.write (attr, 'H5T_NATIVE_DOUBLE', wdata);

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
% Open file, dataset, and attribute.
%
file = H5F.open (fileName, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
dset = H5D.open (file, DATASET);
attr = H5A.open_name (dset, ATTRIBUTE);

%
% Get dataspace
%
space = H5A.get_space (attr);
[~, dims, ~] = H5S.get_simple_extent_dims (space);
dims=fliplr(dims);

%
% Read the data.
%
rdata=H5A.read (attr, 'H5T_NATIVE_DOUBLE');

%
% Output the data to the screen.
%
fprintf ('%s:\n', ATTRIBUTE);
for i=1: dims(1)
    fprintf (' [');
    for j=1: dims(2)
        fprintf (' %6.4f', rdata(i,j));
    end
    fprintf (']\n');
end

%
% Close and release resources.
%
H5D.close (dset);
H5S.close (space);
H5F.close (file);
