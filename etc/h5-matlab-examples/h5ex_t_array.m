function h5ex_t_array
%**************************************************************************
%
%  This example shows how to read and write array datatypes
%  to a dataset.  The program first writes integers arrays of
%  dimension ADIM0xADIM1 to a dataset with a dataspace of
%  DIM0, then closes the  file.  Next, it reopens the file,
%  reads back the data, and outputs it to the screen.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

fileName       = 'h5ex_t_array.h5';
DATASET        = 'DS1';
DIM0           = 4;
ADIM0          = 3;
ADIM1          = 5;

dims  = DIM0;
adims = [ADIM0, ADIM1];
wdata = int32(zeros([ADIM0,ADIM1,DIM0]));      % Write buffer %

%
% Initialize data.  i is the element in the dataspace, j and k the
% elements within the array datatype.
%

for i=1: DIM0
    for j=1: ADIM0
        for k=1: ADIM1
            wdata(j,k,i) = (i-1) * (j-1) - (j-1) * (k-1) + (i-1) * (k-1);
        end
    end
end

%
%% Create a new file using the default properties.
%
file = H5F.create (fileName, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Create array datatypes for file and memory.
%
filetype = H5T.array_create ('H5T_STD_I64LE', 2,fliplr(adims), []);
memtype  = H5T.array_create ('H5T_NATIVE_INT', 2,fliplr(adims), []);

%
% Create dataspace.  Setting maximum size to [] sets the maximum
% size to be the current size.
%
space = H5S.create_simple (1, fliplr(dims), []);

%
% Create the dataset and write the array data to it.
%
dset = H5D.create (file, DATASET, filetype, space, 'H5P_DEFAULT');
H5D.write (dset, memtype, 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT',wdata);

%
% Close and release resources.
%
H5D.close (dset);
H5S.close (space);
H5T.close (filetype);
H5T.close (memtype);
H5F.close (file);


%
%% Now we begin the read section of this example.  Here we assume
% the dataset and array have the same name and rank, but can have
% any size.  Therefore we must allocate a new array to read in
% data using malloc().
%

%
% Open file and dataset.
%
file = H5F.open (fileName, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
dset = H5D.open (file, DATASET);

%
% Get the datatype and its dimensions.
%
filetype = H5D.get_type (dset);
[~, adims]= H5T.get_array_dims (filetype);
adims=fliplr(adims);

%
% Get dataspace and allocate memory for read buffer.  This is a
% three dimensional dataset when the array datatype is included.
%
space = H5D.get_space (dset);
[~, dims]  = H5S.get_simple_extent_dims (space);
dims=fliplr(dims);

%
% Allocate array of pointers to two-dimensional arrays (the
% elements of the dataset.
%
% rdata = int32( zeros( adims(1),adims(2),dims(1) ) );

%
% Create the memory datatype.
%
memtype = H5T.array_create ('H5T_NATIVE_INT', 2, fliplr(adims), []);

%
% Read the data.
%
rdata=H5D.read (dset, memtype, 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');

%
% Output the data to the screen.
%
for i=1: dims(1)
    fprintf ('%s(%d):\n', DATASET, k);
    for j=1: adims(1)
        fprintf (' [');
        for k=1: adims(2)
            fprintf (' %3d', rdata(j,k,i));
        end
        fprintf (']\n');
    end
    
    fprintf('\n');
end

%
% Close and release resources.
%
H5D.close (dset);
H5S.close (space);
H5T.close (filetype);
H5T.close (memtype);
H5F.close (file);

