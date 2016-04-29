function h5ex_d_extern
%**************************************************************************
%
%   This example shows how to read and write data to an
%   external dataset.  The program first writes integers to an
%   external dataset with dataspace dimensions of DIM0xDIM1,
%   then closes the file.  Next, it reopens the file, reads
%   back the data, and outputs the name of the external data
%   file and the data to the screen.
%
%   This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

FILE          = 'h5ex_d_extern.h5';
EXTERNAL      = 'h5ex_d_extern.data';
DATASET       = 'DS1';
DIM0          = 4;
DIM1          = 7;
%NAME_BUF_SIZE = 32;

dims = [DIM0, DIM1];

%
% Initialize data.
%
wdata = int32(zeros(dims));
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
% Create the dataset creation property list, set the external
% file.
%
dcpl = H5P.create ('H5P_DATASET_CREATE');
H5P.set_external (dcpl, EXTERNAL, 0,'H5F_UNLIMITED');

%
% Create the external dataset.
%
dset = H5D.create (file, DATASET,'H5T_STD_I32LE', space, dcpl);

%
% Write the data to the dataset.
%
H5D.write (dset,'H5T_NATIVE_INT','H5S_ALL','H5S_ALL','H5P_DEFAULT', wdata);

%
% Close and release resources.
%
H5P.close (dcpl);
H5D.close (dset);
H5S.close (space);
H5F.close (file);

%
%% Now we begin the read section of this example.
%

%
% Open file and dataset using the default properties.
%
file = H5F.open(FILE,'H5F_ACC_RDONLY','H5P_DEFAULT');
dset = H5D.open(file, DATASET);

%
% Retrieve dataset creation property list.
%
dcpl = H5D.get_create_plist (dset);

%
% Retrieve and print the name of the external file.
%
[name, ~, ~] = H5P.get_external (dcpl, 0);
fprintf ('%s is stored in file: %s\n', DATASET, name);

%
% Read the data using the default properties.
%
rdata = H5D.read(dset,'H5T_NATIVE_INT','H5S_ALL','H5S_ALL','H5P_DEFAULT');

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
H5P.close (dcpl);
H5D.close (dset);
H5F.close (file);

