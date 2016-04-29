function h5ex_d_gzip
%**************************************************************************
%
%   This example shows how to read and write data to a dataset
%   using gzip compression (also called zlib or deflate).  The
%   program first checks if gzip compression is available,
%   then if it is it writes integers to a dataset using gzip,
%   then closes the file.  Next, it reopens the file, reads
%   back the data, and outputs the type of compression and the
%   maximum value in the dataset to the screen.
%
%   This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

FILE    = 'h5ex_d_gzip.h5';
DATASET = 'DS1';
DIM0    = 32;
DIM1    = 64;
CHUNK0  = 4;
CHUNK1  = 8;

dims  = [DIM0, DIM1];
chunk = [CHUNK0, CHUNK1];

%
% Check if gzip compression is available and can be used for both
% compression and decompression.  Normally we do not perform error
% checking in these examples for the sake of clarity, but in this
% case we will make an exception because this filter is an
% optional part of the hdf5 library.
%
avail = H5Z.filter_avail('H5Z_FILTER_DEFLATE');
if ~avail
    error ('gzip filter not available.');
end

% Check that it can be used.
H5Z_FILTER_CONFIG_ENCODE_ENABLED = H5ML.get_constant_value('H5Z_FILTER_CONFIG_ENCODE_ENABLED');
H5Z_FILTER_CONFIG_DECODE_ENABLED = H5ML.get_constant_value('H5Z_FILTER_CONFIG_DECODE_ENABLED');
filter_info = H5Z.get_filter_info('H5Z_FILTER_DEFLATE');
if ( ~bitand(filter_info,H5Z_FILTER_CONFIG_ENCODE_ENABLED) || ...
        ~bitand(filter_info,H5Z_FILTER_CONFIG_DECODE_ENABLED) )
    error ('gzip filter not available for encoding and decoding.');
end

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
% Create dataspace.  Setting maximum size to [] sets the maximum
% size to be the current size.  Remember to flip the dimensions.
%
space = H5S.create_simple (2, fliplr(dims), []);

%
% Create the dataset creation property list, add the gzip
% compression filter and set the chunk size.  Remember to flip
% the chunksize.
%
dcpl = H5P.create('H5P_DATASET_CREATE');
H5P.set_deflate (dcpl, 9);
H5P.set_chunk (dcpl, fliplr(chunk));

%
% Create the dataset.
%
dset = H5D.create(file,DATASET,'H5T_STD_I32LE',space,dcpl);

%
% Write the data to the dataset.
%
H5D.write(dset,'H5T_NATIVE_INT','H5S_ALL','H5S_ALL','H5P_DEFAULT',wdata);

%
% Close and release resources.
%
H5P.close(dcpl);
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
dset = H5D.open(file,DATASET);

%
% Retrieve dataset creation property list.
%
dcpl = H5D.get_create_plist(dset);

%
% Retrieve and print the filter type.  Here we only retrieve the
% first filter because we know that we only added one filter.
%
[filter_type, ~, ~, ~] = H5P.get_filter (dcpl, 0);
fprintf('Filter type is: ');
switch (filter_type)
    case H5ML.get_constant_value('H5Z_FILTER_DEFLATE')
        fprintf ('H5Z_FILTER_DEFLATE\n');
        
    case H5ML.get_constant_value('H5Z_FILTER_SHUFFLE')
        fprintf ('H5Z_FILTER_SHUFFLE\n');
        
    case H5ML.get_constant_value('H5Z_FILTER_FLETCHER32')
        fprintf ('H5Z_FILTER_FLETCHER32\n');
        
    case H5ML.get_constant_value('H5Z_FILTER_SZIP')
        fprintf ('H5Z_FILTER_SZIP\n');
end

%
% Read the data using the default properties.
%
rdata = H5D.read (dset,'H5T_NATIVE_INT','H5S_ALL','H5S_ALL','H5P_DEFAULT');

%
% Find the maximum value in the dataset, to verify that it was
% read correctly.
%
maxdata = max(rdata(:));

%
% Print the maximum value.
fprintf('Maximum value in %s is: %d\n', DATASET, maxdata);

%
% Close and release resources.
%
H5P.close(dcpl);
H5D.close(dset);
H5F.close(file);


