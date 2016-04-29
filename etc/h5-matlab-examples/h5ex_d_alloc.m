function h5ex_d_alloc
%**************************************************************************
%
%  This example shows how to set the space allocation time
%  for a dataset.  The program first creates two datasets,
%  one with the default allocation time (late) and one with
%  early allocation time, and displays whether each has been
%  allocated and their allocation size.  Next, it writes data
%  to the datasets, and again displays whether each has been
%  allocated and their allocation size.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

FILE='h5ex_d_alloc.h5';
DATASET1='DS1';
DATASET2='DS2';
DIM0=4;
DIM1=7;

dims = [DIM0, DIM1];

%
% Initialize data.
%
wdata = int32(zeros(DIM0,DIM1));
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
% size to be the current size.  Remember to flip the dataspace so that
% we don't have to transpose the data.
%
space = H5S.create_simple (2, fliplr(dims), []);

%
% Create the dataset creation property list, and set the chunk
% size.
%
dcpl = H5P.create('H5P_DATASET_CREATE');

%
% Set the allocation time to "early".  This way we can be sure
% that reading from the dataset immediately after creation will
% return the fill value.
%
H5P.set_alloc_time (dcpl, 'H5D_ALLOC_TIME_EARLY');

fprintf ('Creating datasets...\n');
fprintf ('%s has allocation time H5D_ALLOC_TIME_LATE\n', DATASET1);
fprintf ('%s has allocation time H5D_ALLOC_TIME_EARLY\n\n', DATASET2);

%
% Create the dataset using the dataset creation property list.
%
dset1 = H5D.create (file, DATASET1, 'H5T_STD_I32LE', space, 'H5P_DEFAULT');
dset2 = H5D.create (file, DATASET2, 'H5T_STD_I32LE', space, dcpl);

%
% Retrieve and print space status and storage size for dset1.
%
H5D_SPACE_STATUS_ALLOCATED = H5ML.get_constant_value('H5D_SPACE_STATUS_ALLOCATED');

space_status = H5D.get_space_status (dset1);
storage_size = H5D.get_storage_size (dset1);

if ( space_status == H5D_SPACE_STATUS_ALLOCATED )
    fprintf ('Space for %s has been allocated.\n', DATASET1 );
else
    fprintf ('Space for %s has not been allocated.\n', DATASET1 );
end
fprintf ('Storage size for %s is: %ld bytes.\n', DATASET1, storage_size);

%
% Retrieve and print space status and storage size for dset2.
%
space_status = H5D.get_space_status (dset2);
storage_size = H5D.get_storage_size (dset2);
if ( space_status == H5D_SPACE_STATUS_ALLOCATED )
    fprintf ('Space for %s has been allocated.\n', DATASET2 );
else
    fprintf ('Space for %s has not been allocated.\n', DATASET2 );
end
fprintf ('Storage size for %s is: %ld bytes.\n', DATASET2, storage_size);

fprintf ('\nWriting data...\n\n');

%
% Write the data to the datasets.
%
H5D.write (dset1,'H5T_NATIVE_INT','H5S_ALL','H5S_ALL','H5P_DEFAULT',wdata);
H5D.write (dset2,'H5T_NATIVE_INT','H5S_ALL','H5S_ALL','H5P_DEFAULT',wdata);

%
%% Retrieve and print space status and storage size for dset1.
%
space_status = H5D.get_space_status (dset1);
storage_size = H5D.get_storage_size (dset1);

if ( space_status == H5D_SPACE_STATUS_ALLOCATED )
    fprintf ('Space for %s has been allocated.\n', DATASET1 );
else
    fprintf ('Space for %s has not been allocated.\n', DATASET1 );
end
fprintf ('Storage size for %s is: %ld bytes.\n', DATASET1, storage_size);

%
% Retrieve and print space status and storage size for dset2.
%
space_status = H5D.get_space_status (dset2);
storage_size = H5D.get_storage_size (dset2);

if ( space_status == H5D_SPACE_STATUS_ALLOCATED )
    fprintf ('Space for %s has been allocated.\n', DATASET2 );
else
    fprintf ('Space for %s has not been allocated.\n', DATASET2 );
end
fprintf ('Storage size for %s is: %ld bytes.\n', DATASET2, storage_size);


%
% Close and release resources.
%
H5P.close (dcpl);
H5D.close (dset1);
H5D.close (dset2);
H5S.close (space);
H5F.close (file);


