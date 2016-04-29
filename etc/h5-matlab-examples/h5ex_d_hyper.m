function h5ex_d_hyper
%**************************************************************************
%
%   This example shows how to read and write data to a
%   dataset by hyberslabs.  The program first writes integers
%   in a hyperslab selection to a dataset with dataspace
%   dimensions of DIM0xDIM1, then closes the file.  Next, it
%   reopens the file, reads back the data, and outputs it to
%   the screen.  Finally it reads the data again using a
%   different hyperslab selection, and outputs the result to
%   the screen.
%
%   This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

FILE    = 'h5ex_d_hyper.h5';
DATASET = 'DS1';
DIM0    = 6;
DIM1    = 8;

dims = [DIM0, DIM1];

%
% Initialize data to "1", to make it easier to see the selections.
%
wdata = ones([DIM0 DIM1], 'int32');

%
% Print the data to the screen.
%
fprintf('Original Data:\n');
for i=1:DIM0
    fprintf (' [');
    for j=1:DIM1
        fprintf (' %3d', wdata(i,j));
    end
    fprintf (']\n');
end

%
%% Create a new file using the default properties.
%
file = H5F.create(FILE,'H5F_ACC_TRUNC','H5P_DEFAULT','H5P_DEFAULT');

%
% Create dataspace.  Setting maximum size to [] sets the maximum
% size to be the current size.  Remember to flip the dimensions.
%
space = H5S.create_simple (2,fliplr(dims),[]);

%
% Create the dataset.  We will use all default properties for this
% example.
%
dset = H5D.create(file,DATASET,'H5T_STD_I32LE',space,'H5P_DEFAULT');

%
% Define and select the first part of the hyperslab selection.
% Remember to flip the dimensions.
%
start  = [0 0];
stride = [3 3];
count  = [2 3];
block  = [2 2];
H5S.select_hyperslab (space,'H5S_SELECT_SET',fliplr(start), ...
    fliplr(stride), ...
    fliplr(count), ...
    fliplr(block) );

%
% Define and select the second part of the hyperslab selection,
% which is subtracted from the first selection by the use of
% Remember to flip the dimensions.
% H5S_SELECT_NOTB
%
block  = [1 1];
H5S.select_hyperslab (space,'H5S_SELECT_NOTB', fliplr(start), ...
    fliplr(stride), ...
    fliplr(count), ...
    fliplr(block)  );

%
% Write the data to the dataset.
%
H5D.write (dset,'H5T_NATIVE_INT','H5S_ALL',space,'H5P_DEFAULT',wdata);

%
% Close and release resources.
%
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
dset = H5D.open(file,DATASET);

%
% Read the data using the default properties.
%
rdata = H5D.read(dset,'H5T_NATIVE_INT','H5S_ALL','H5S_ALL','H5P_DEFAULT');

%
% Output the data to the screen.
%
fprintf('\nData as written to disk by hyberslabs:\n');
for i=1:DIM0
    fprintf (' [');
    for j=1:DIM1
        fprintf (' %3d', rdata(i,j));
    end
    fprintf (']\n');
end

%
% Initialize the read array.
%
% rdata = zeros([DIM0 DIM1],'int32');

%
% Define and select the hyperslab to use for reading.
% Remember to flip the dimensions.
%
space  = H5D.get_space(dset);
start  = [0 1];
stride = [4 4];
count  = [2 2];
block  = [2 3];
H5S.select_hyperslab(space,'H5S_SELECT_SET', fliplr(start), ...
    fliplr(stride), ...
    fliplr(count), ...
    fliplr(block)   );

%
% Read the data using the previously defined hyperslab.
%
rdata = H5D.read(dset,'H5T_NATIVE_INT','H5S_ALL',space,'H5P_DEFAULT');

%
% Output the data to the screen.
%
fprintf('\nData as read from disk by hyperslab:\n');
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
H5D.close(dset);
H5S.close(space);
H5F.close(file);

