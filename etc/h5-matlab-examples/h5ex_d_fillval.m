function h5ex_d_fillval
%**************************************************************************
%
%  This example shows how to set the fill value for a
%  dataset.  The program first sets the fill value to
%  FILLVAL, creates a dataset with dimensions of DIM0xDIM1,
%  reads from the uninitialized dataset, and outputs the
%  contents to the screen.  Next, it writes integers to the
%  dataset, reads the data back, and outputs it to the
%  screen.  Finally it extends the dataset, reads from it,
%  and outputs the result to the screen.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

FILE =           'h5ex_d_fillval.h5';
DATASET =        'DS1';
DIM0 =           4;
DIM1 =           7;
EDIM0 =          6;
EDIM1 =          10;
CHUNK0 =         4;
CHUNK1 =         4;
FILLVAL =        99;

dims= [DIM0, DIM1];
extdims= [EDIM0, EDIM1];
maxdims = [H5ML.get_constant_value('H5S_UNLIMITED'),...
    H5ML.get_constant_value('H5S_UNLIMITED')];
chunk= [CHUNK0, CHUNK1];

%
% Initialize data.
%
wdata=zeros(dims,'int32');
for i=1:DIM0
    for j=1:DIM1
        ci=i-1;
        cj=j-1;
        wdata(i,j) = int32(ci * cj - cj);
    end
end

%
%% Create a new file using the default properties.
%
file = H5F.create (FILE, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Create dataspace with unlimited dimensions.
%
space = H5S.create_simple (2, fliplr(dims), fliplr(maxdims));

%
% Create the dataset creation property list, and set the chunk
% size.
%
dcpl = H5P.create ('H5P_DATASET_CREATE');
H5P.set_chunk (dcpl,chunk);

%
%% Set the fill value for the dataset.
%
fillval = int32(FILLVAL);
H5P.set_fill_value (dcpl, 'H5T_NATIVE_INT', fillval);

%
% Set the allocation time to 'early'.  This way we can be sure
% that reading from the dataset immediately after creation will
% return the fill value.
%
H5P.set_alloc_time (dcpl, 'H5D_ALLOC_TIME_EARLY');

%
%% Create the dataset using the dataset creation property list.
%
dset = H5D.create (file, DATASET, 'H5T_STD_I32LE', space,...
    'H5P_DEFAULT', dcpl,'H5P_DEFAULT');

%
% Read values from the dataset, which has not been written to yet.
%
rdata=...
    H5D.read (dset, 'H5T_NATIVE_INT', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');

%
% Output the data to the screen.
%
fprintf(1,'Dataset before being written to:\n');
disp(rdata);

%
%% Write the data to the dataset.
%
H5D.write(dset, 'H5T_NATIVE_INT', 'H5S_ALL',...
    'H5S_ALL', 'H5P_DEFAULT',wdata);

%
% Read the data back.
%
rdata=...
    H5D.read (dset, 'H5T_NATIVE_INT', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');

%
% Output the data to the screen.
%
fprintf(1,'\nDataset after being written to:\n');
disp(rdata);

%
%% Extend the dataset.
%
H5D.set_extent (dset, fliplr(extdims));

%
% Read from the extended dataset.
%
rdata=...
    H5D.read (dset, 'H5T_NATIVE_INT', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');

%
% Output the data to the screen.
%
fprintf(1,'\nDataset after extension:\n');
disp(rdata);
%
% Close and release resources.
%
H5P.close (dcpl);
H5D.close (dset);
H5S.close (space);
H5F.close (file);


