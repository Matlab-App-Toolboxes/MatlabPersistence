function h5ex_d_rdwr
%**************************************************************************
%
%   This example shows how to read and write data to a
%   dataset.  The program first writes integers to a dataset
%   with dataspace dimensions of DIM0xDIM1, then closes the
%   file.  Next, it reopens the file, reads back the data, and
%   outputs it to the screen.
%
%   This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

FILE    = 'h5ex_d_rdwr.h5';
DATASET = 'DS1';
DIM0    = 4;
DIM1    = 7;

dims = [DIM0, DIM1];

%
% Initialize data.
%
wdata = zeros(dims,'int32');
for i = 1:DIM0
    for j = 1:DIM1
        ii=i-1;
        jj=j-1;
        wdata(i,j) = ii * jj - jj;
    end
end

%
%% Create a new file using the default properties.
%
file = H5F.create (FILE,'H5F_ACC_TRUNC','H5P_DEFAULT','H5P_DEFAULT');

%
% Create dataspace.  Setting maximum size to [] sets the maximum
% size to be the current size.
%
space = H5S.create_simple (2, fliplr(dims), []);

%
% Create the dataset.  We will use all default properties for this
% example.
%
dset = H5D.create (file, DATASET,'H5T_STD_I32LE',space,'H5P_DEFAULT');

%
% Write the data to the dataset.
%
H5D.write (dset,'H5T_NATIVE_INT','H5S_ALL','H5S_ALL','H5P_DEFAULT', wdata);

%
% Close and release resources.
%
H5D.close(dset);
H5S.close(space);
H5F.close(file);

%
%% Now we begin the read section of this example.
%

%
% Open file and dataset using the default properties.
%
file = H5F.open(FILE,'H5F_ACC_RDONLY','H5P_DEFAULT');
dset = H5D.open(file, DATASET);

%
% Read the data using the default properties.
%
rdata = H5D.read (dset,'H5T_NATIVE_INT','H5S_ALL','H5S_ALL','H5P_DEFAULT');

%
% Output the data to the screen.
%
fprintf ('%s:\n', DATASET);

for i=1:DIM0
    fprintf (' [');
    for j=1:DIM1
        fprintf (' %3d', rdata(i,j));
    end
    fprintf (']\n');
end

%
% Close and release resources.
%
H5D.close (dset);
H5F.close (file);

