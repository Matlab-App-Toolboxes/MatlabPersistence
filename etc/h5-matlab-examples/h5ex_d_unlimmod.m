function h5ex_d_unlimmod
%**************************************************************************
%
%  This example shows how to create and extend an unlimited
%  dataset.  The program first writes integers to a dataset
%  with dataspace dimensions of DIM0xDIM1, then closes the
%  file.  Next, it reopens the file, reads back the data,
%  outputs it to the screen, extends the dataset, and writes
%  new data to the entire extended dataset.  Finally it
%  reopens the file again, reads back the data, and utputs it
%  to the screen.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

FILE =           'h5ex_d_unlimmod.h5';
DATASET =        'DS1';
DIM0 =           4;
DIM1 =           7;
EDIM0 =          6;
EDIM1 =          10;
CHUNK0 =         4;
CHUNK1 =         4;

dims = [DIM0, DIM1];
extdims= [EDIM0, EDIM1];

chunk= [CHUNK0, CHUNK1];

%
% Initialize data.
%
wdata=zeros(dims,'int32');
for i=1:DIM0
    for j=1:DIM1
        ci=i-1;
        cj=j-1;
        wdata(i,j) = ci * cj - cj;
    end
end

%
%% Create a new file using the default properties.
%
file = H5F.create (FILE, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Create dataspace with unlimited dimensions.
%
maxdims(1) = H5ML.get_constant_value('H5S_UNLIMITED');
maxdims(2) = H5ML.get_constant_value('H5S_UNLIMITED');
space = H5S.create_simple (2, fliplr(dims), fliplr(maxdims));

%
% Create the dataset creation property list, and set the chunk
% size.
%
dcpl = H5P.create ('H5P_DATASET_CREATE');
H5P.set_chunk (dcpl, fliplr(chunk));

%
% Create the unlimited dataset.
%
dset = H5D.create (file, DATASET, 'H5T_STD_I32LE',...
    space, 'H5P_DEFAULT', dcpl,'H5P_DEFAULT');

%
%% Write the data to the dataset.
%
H5D.write (dset, 'H5T_NATIVE_INT',...
    'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT',wdata);

%
% Close and release resources.
%
H5P.close (dcpl);
H5D.close (dset);
H5S.close (space);
H5F.close (file);


%
%% In this next section we read back the data, extend the dataset,
% and write new data to the entire dataset.
%

%
% Open file and dataset using the default properties.
%
file = H5F.open (FILE, 'H5F_ACC_RDWR', 'H5P_DEFAULT');
dset = H5D.open (file, DATASET, 'H5P_DEFAULT');

%
% Get dataspace and allocate memory for read buffer.  This is a
% two dimensional dataset so the dynamic allocation must be done
% in steps.
%
space = H5D.get_space (dset);

%
% Read the data using the default properties.
%
rdata=...
    H5D.read (dset, 'H5T_NATIVE_INT', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');

%
% Output the data to the screen.
%
fprintf(1,'Dataset before extension:\n');
disp(rdata);

%
% Extend the dataset.
%
H5D.set_extent (dset, fliplr(extdims));

%
% Initialize data for writing to the extended dataset.
%
wdata2=ones([EDIM0,EDIM1],'int32');
for j=1:EDIM1
    wdata2(:,j)=j-1;
end
%
% Write the data to the extended dataset.
%
H5D.write (dset, 'H5T_NATIVE_INT',...
    'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT',wdata2);

%
% Close and release resources.
%

H5D.close (dset);
H5S.close (space);
H5F.close (file);


%
%% Now we simply read back the data and output it to the screen.
%

%
% Open file and dataset using the default properties.
%
file = H5F.open (FILE, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
dset = H5D.open (file, DATASET, 'H5P_DEFAULT');

%
% Get dataspace and allocate memory for the read buffer as before.
%
space = H5D.get_space (dset);

%
% Read the data using the default properties.
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
H5D.close (dset);
H5S.close (space);
H5F.close (file);

