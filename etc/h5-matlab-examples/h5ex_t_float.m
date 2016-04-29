function h5ex_t_float
%**************************************************************************
%
% This example shows how to read and write integer datatypes
% to a dataset.  The program first writes integers to a
% dataset with a dataspace of DIM0xDIM1, then closes the
% file.  Next, it reopens the file, reads back the data, and
% outputs it to the screen.
%
% This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

fileName       = 'h5ex_t_float.h5';
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
file = H5F.create (fileName, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

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
% Close and release resources.
%
H5D.close (dset);
H5S.close (space);
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
% Get dataspace
%
space = H5D.get_space (dset);
[~, dims,~]= H5S.get_simple_extent_dims (space);
dims=fliplr(dims);

%
% Read the data.
%
rdata=H5D.read (dset,'H5T_NATIVE_DOUBLE', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');

%
% Output the data to the screen.
%
fprintf ('%s:\n', DATASET);
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

