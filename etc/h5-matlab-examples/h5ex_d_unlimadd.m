function h5ex_d_unlimadd
%**************************************************************************
%
%   This example shows how to create and extend an unlimited
%   dataset.  The program first writes integers to a dataset
%   with dataspace dimensions of DIM0xDIM1, then closes the
%   file.  Next, it reopens the file, reads back the data,
%   outputs it to the screen, extends the dataset, and writes
%   new data to the extended portions of the dataset.  Finally
%   it reopens the file again, reads back the data, and
%   outputs it to the screen.
%
%   This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

FILE    = 'h5ex_d_unlimadd.h5';
DATASET = 'DS1';
DIM0    = 4;
DIM1    = 7;
EDIM0   = 6;
EDIM1   = 10;
CHUNK0  = 4;
CHUNK1  = 4;

dims    = [DIM0, DIM1];
extdims = [EDIM0, EDIM1];
chunk   = [CHUNK0, CHUNK1];

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
% Create dataspace with unlimited dimensions.
%
H5S_UNLIMITED = H5ML.get_constant_value('H5S_UNLIMITED');
maxdims = [H5S_UNLIMITED H5S_UNLIMITED];
space = H5S.create_simple(2, fliplr(dims), fliplr(maxdims));

%
% Create the dataset creation property list, and set the chunk
% size.
%
dcpl = H5P.create('H5P_DATASET_CREATE');
H5P.set_chunk (dcpl, fliplr(chunk));

%
% Create the unlimited dataset.
%
dset = H5D.create(file,DATASET,'H5T_STD_I32LE',space,dcpl);

%
% Write the data to the dataset.
%
H5D.write(dset,'H5T_NATIVE_INT','H5S_ALL','H5S_ALL','H5P_DEFAULT', wdata);

%
% Close and release resources.
%
H5P.close(dcpl);
H5D.close(dset);
H5S.close(space);
H5F.close(file);


%
%% In this next section we read back the data, extend the dataset,
% and write new data to the extended portions.
%

%
% Open file and dataset using the default properties.
%
file = H5F.open(FILE,'H5F_ACC_RDWR','H5P_DEFAULT');
dset = H5D.open(file,DATASET);

%
% Read the data using the default properties.
%
rdata = H5D.read (dset,'H5T_NATIVE_INT','H5S_ALL','H5S_ALL','H5P_DEFAULT');

%
% Output the data to the screen.
%
fprintf ('Dataset before extension:\n');
for i=1:DIM0
    fprintf (' [');
    for j=1:DIM1
        fprintf (' %3d', rdata(i,j));
    end
    fprintf (']\n');
end

%
% Extend the dataset.
%
H5D.extend(dset,fliplr(extdims));

%
% Retrieve the dataspace for the newly extended dataset.
%
space = H5D.get_space(dset);

%
% Initialize data for writing to the extended dataset.
%
wdata2 = zeros(extdims,'int32');
for i=1:EDIM0
    for j=1:EDIM1
        wdata2(i,j) = j-1;
    end
end

%
% Select the entire dataspace.
%
H5S.select_all(space);

%
% Subtract a hyperslab reflecting the original dimensions from the
% selection.  The selection now contains only the newly extended
% portions of the dataset.
%
start = [0 0];
count = dims;
H5S.select_hyperslab(space,'H5S_SELECT_NOTB',fliplr(start),[],fliplr(count),[]);

%
% Write the data to the selected portion of the dataset.
%
H5D.write(dset,'H5T_NATIVE_INT','H5S_ALL',space,'H5P_DEFAULT',wdata2);

%
% Close and release resources.
%
H5D.close(dset);
H5S.close(space);
H5F.close(file);


%
%% Now we simply read back the data and output it to the screen.
%

%
% Open file and dataset using the default properties.
%
file = H5F.open(FILE,'H5F_ACC_RDONLY','H5P_DEFAULT');
dset = H5D.open(file, DATASET);


%
% Read the data using the default properties.
%
rdata = H5D.read(dset,'H5T_NATIVE_INT','H5S_ALL','H5S_ALL','H5P_DEFAULT');

%
% Output the data to the screen.
%
fprintf('\nDataset after extension:\n');
fprintf ('Dataset before extension:\n');
for i=1:EDIM0
    fprintf (' [');
    for j=1:EDIM1
        fprintf (' %3d', rdata(i,j));
    end
    fprintf (']\n');
end

%
% Close and release resources.
%
H5D.close(dset);
H5F.close(file);

