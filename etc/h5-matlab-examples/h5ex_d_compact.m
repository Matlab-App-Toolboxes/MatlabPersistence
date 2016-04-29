function h5ex_d_compact
%**************************************************************************
%
% This example shows how to read and write data to a compact
% dataset.  The program first writes integers to a compact
% dataset with dataspace dimensions of DIM0xDIM1, then
% closes the file.  Next, it reopens the file, reads back
% the data, and outputs it to the screen.
%
% This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

FILE='h5ex_d_compact.h5';
DATASET='DS1';
DIM0=4;
DIM1=7;

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
file = H5F.create(FILE,'H5F_ACC_TRUNC','H5P_DEFAULT','H5P_DEFAULT');

%
% Create dataspace.  Setting maximum size to NULL sets the maximum
% size to be the current size.  Remember to flip the dimensions.
%
space = H5S.create_simple (2, fliplr(dims), []);

%
% Create the dataset creation property list, set the layout to
% compact.
%
dcpl = H5P.create('H5P_DATASET_CREATE');
H5P.set_layout (dcpl,'H5D_COMPACT');

%
% Create the dataset.
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
file = H5F.open (FILE,'H5F_ACC_RDONLY','H5P_DEFAULT');
dset = H5D.open (file, DATASET);

%
% Retrieve the dataset creation property list, and print the
% storage layout.
%
dcpl = H5D.get_create_plist(dset);
layout = H5P.get_layout (dcpl);
fprintf ('Storage layout for %s is: ', DATASET);
switch (layout)
    case H5ML.get_constant_value('H5D_COMPACT')
        fprintf ('H5D_COMPACT\n');
        
    case H5ML.get_constant_value('H5D_CONTIGUOUS')
        fprintf ('H5D_CONTIGUOUS\n');
        
    case H5ML.get_constant_value('H5D_CHUNKED')
        fprintf ('H5D_CHUNKED\n');
end

%
% Read the data using the default properties.
%
rdata = H5D.read(dset,'H5T_NATIVE_INT','H5S_ALL','H5S_ALL','H5P_DEFAULT');

%
% Output the data to the screen.
%
fprintf ('%s:\n', DATASET);
for i = 1:DIM0
    fprintf (' [');
    for j = 1:DIM1
        fprintf (' %3d', rdata(i,j));
    end
    fprintf (']\n');
    
end

%
% Close and release resources.
%
H5P.close(dcpl);
H5D.close(dset);
H5F.close(file);


