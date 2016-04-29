function h5ex_d_chunk
%**************************************************************************
%
%  This example shows how to create a chunked dataset.  The
%  program first writes integers in a hyperslab selection to
%  a chunked dataset with dataspace dimensions of DIM0xDIM1
%  and chunk size of CHUNK0xCHUNK1, then closes the file.
%  Next, it reopens the file, reads back the data, and
%  outputs it to the screen.  Finally it reads the data again
%  using a different hyperslab selection, and outputs
%  the result to the screen.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

FILE    =        'h5ex_d_chunk.h5';
DATASET =        'DS1';
DIM0    =        6;
DIM1    =        8;
CHUNK0  =        4;
CHUNK1  =        4;

dims = [DIM0, DIM1];
chunk= [CHUNK0, CHUNK1];

%
% Initialize data to '1', to make it easier to see the selections.
%
wdata=ones(dims,'uint32');

%
% Print the data to the screen.
%
fprintf(1,'Original Data:\n');
disp(wdata);

%
%% Create a new file using the default properties.
%
file = H5F.create (FILE, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Create dataspace.  Setting maximum size to [] sets the maximum
% size to be the current size.
%
space = H5S.create_simple (2, fliplr(dims), []);

%
% Create the dataset creation property list, and set the chunk
% size.
%
dcpl = H5P.create ('H5P_DATASET_CREATE');
H5P.set_chunk (dcpl,chunk);

%
% Create the chunked dataset.
%
dset = H5D.create (file, DATASET, 'H5T_STD_I32LE', space,...
    'H5P_DEFAULT', dcpl,'H5P_DEFAULT');

%
% Define and select the first part of the hyperslab selection.
%
start(1) = 0;
start(2) = 0;
stride(1) = 3;
stride(2) = 3;
count(1) = 2;
count(2) = 3;
block(1) = 2;
block(2) = 2;
H5S.select_hyperslab (space, 'H5S_SELECT_SET', ...
    fliplr(start),...
    fliplr(stride),...
    fliplr(count),...
    fliplr(block));

%
% Define and select the second part of the hyperslab selection,
% which is subtracted from the first selection by the use of
% 'H5S_SELECT_NOTB
%
block(1) = 1;
block(2) = 1;
H5S.select_hyperslab (space,'H5S_SELECT_NOTB',...
    fliplr(start),...
    fliplr(stride),...
    fliplr(count),...
    fliplr(block));

%
%% Write the data to the dataset.
%
H5D.write (dset, 'H5T_NATIVE_INT', 'H5S_ALL', space, 'H5P_DEFAULT',wdata);

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
file = H5F.open (FILE, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
dset = H5D.open (file, DATASET, 'H5P_DEFAULT');

%
% Retrieve the dataset creation property list, and print the
% storage layout.
%
dcpl = H5D.get_create_plist (dset);
layout = H5P.get_layout (dcpl);
fprintf(1,'\nStorage layout for %s is: ', DATASET);

switch layout
    case H5ML.get_constant_value('H5D_COMPACT')
        fprintf(1,'H5D_COMPACT\n');
    case H5ML.get_constant_value('H5D_CONTIGUOUS')
        fprintf(1,'H5D_CONTIGUOUS\n');
    case H5ML.get_constant_value('H5D_CHUNKED')
        fprintf(1,'H5D_CHUNKED\n');
end

%
% Read the data using the default properties.
%
rdata=...
    H5D.read (dset, 'H5T_NATIVE_INT', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');

%
% Output the data to the screen.
%
fprintf(1,'\nData as written to disk by hyberslabs:\n');
disp(rdata);


%
% Define and select the hyperslab to use for reading.
%
space = H5D.get_space (dset);
start(1) = 0;
start(2) = 1;
stride(1) = 4;
stride(2) = 4;
count(1) = 2;
count(2) = 2;
block(1) = 2;
block(2) = 3;
H5S.select_hyperslab (space, 'H5S_SELECT_SET', ...
    fliplr(start),...
    fliplr(stride),...
    fliplr(count),...
    fliplr(block));

%
% Read the data using the previously defined hyperslab.
%
rdata=H5D.read (dset, 'H5T_NATIVE_INT', 'H5S_ALL', space, 'H5P_DEFAULT');

%
% Output the data to the screen.
%
fprintf(1,'\nData as read from disk by hyperslab:\n');
disp(rdata);

%
% Close and release resources.
%
H5P.close (dcpl);
H5D.close (dset);
H5S.close (space);
H5F.close (file);

