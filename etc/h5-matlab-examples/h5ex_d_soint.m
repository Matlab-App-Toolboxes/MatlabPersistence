function h5ex_d_soint
%**************************************************************************
%
%   This example shows how to read and write data to a dataset
%   using the Scale-Offset filter.  The program first checks
%   if the Scale-Offset filter is available, then if it is it
%   writes integers to a dataset using Scale-Offset, then
%   closes the file Next, it reopens the file, reads back the
%   data, and outputs the type of filter and the maximum value
%   in the dataset to the screen.
%
%   This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

FILE =            'h5ex_d_soint.h5';
DATASET =         'DS1';
DIM0 =            32;
DIM1 =            64;
CHUNK0 =          4;
CHUNK1 =          8;


dims  = [DIM0, DIM1];
chunk = [CHUNK0, CHUNK1];

%
%% Check if Scale-Offset compression is available and can be used
% for both compression and decompression.  Normally we do not
% perform error checking in these examples for the sake of
% clarity, but in this case we will make an exception because this
% filter is an optional part of the hdf5 library.
%
avail = H5Z.filter_avail('H5Z_FILTER_SCALEOFFSET');
if (~avail)
    disp('Scale-Offset filter not available.\n');
    
end
filter_info=H5Z.get_filter_info ('H5Z_FILTER_SCALEOFFSET');
if ( ~(filter_info && ...
        H5ML.get_constant_value('H5Z_FILTER_CONFIG_ENCODE_ENABLED')) ...
        ||...
        ~(filter_info &&...
        H5ML.get_constant_value('H5Z_FILTER_CONFIG_DECODE_ENABLED') ))
    disp ('Scale-Offset filter not available for encoding and decoding');
    
end

%
% Initialize data.
%
wdata=zeros(dims,'int32');
for i=1:DIM0
    for j=1:DIM1
        ci=i-1;
        cj=j-1;
        wdata(i,j) = int32(ci*cj-cj);
    end
end

%
% Find the maximum value in the dataset, to verify that it was
% read correctly.
%
maxV = max(wdata(:));
minV = min(wdata(:));

%
% Print the maximum value.
%
disp (['Maximum value in write buffer is: ', num2str(maxV)]);
disp (['Minimum value in write buffer is: ', num2str(minV)]);

%
% Create a new file using the default properties.
%
file = H5F.create (FILE, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Create dataspace.  Setting maximum size to [] sets the maximum
% size to be the current size.
%
space = H5S.create_simple (2, fliplr(dims), []);

%
% Create the dataset creation property list, add the Scale-Offset
% filter and set the chunk size.
%
dcpl = H5P.create ('H5P_DATASET_CREATE');
H5P.set_scaleoffset (dcpl, 'H5Z_SO_INT', 'H5Z_SO_INT_MINBITS_DEFAULT');
H5P.set_chunk (dcpl, fliplr(chunk));

%
% Create the dataset.
%
dset = H5D.create (file, DATASET, 'H5T_STD_I32LE', ...
    space, 'H5P_DEFAULT', dcpl,'H5P_DEFAULT');

%
% Write the data to the dataset.
%
H5D.write (dset, 'H5T_NATIVE_INT', 'H5S_ALL',...
    'H5S_ALL', 'H5P_DEFAULT',wdata);

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
% Retrieve dataset creation property list.
%
dcpl = H5D.get_create_plist (dset);

%
% Retrieve and print the filter type.  Here we only retrieve the
% first filter because we know that we only added one filter.
%

filter_type = H5P.get_filter (dcpl, 0);
disp ('Filter type is: ');
switch (filter_type)
    case H5ML.get_constant_value('H5Z_FILTER_DEFLATE')
        disp ('H5Z_FILTER_DEFLATE');
    case H5ML.get_constant_value('H5Z_FILTER_SHUFFLE')
        disp ('H5Z_FILTER_SHUFFLE');
    case H5ML.get_constant_value('H5Z_FILTER_FLETCHER32')
        disp ('H5Z_FILTER_FLETCHER32');
    case H5ML.get_constant_value('H5Z_FILTER_SZIP')
        disp ('H5Z_FILTER_SZIP');
    case H5ML.get_constant_value('H5Z_FILTER_NBIT')
        disp ('H5Z_FILTER_NBIT');
    case H5ML.get_constant_value('H5Z_FILTER_SCALEOFFSET')
        disp ('H5Z_FILTER_SCALEOFFSET');
end

%
% Read the data using the default properties.
%
rdata=...
    H5D.read (dset, 'H5T_NATIVE_INT', 'H5S_ALL',...
    'H5S_ALL', 'H5P_DEFAULT');

%
% Find the maximum value in the dataset, to verify that it was
% read correctly.
%
maxV = max(rdata(:));
minV = min(rdata(:));

%
% Print the maximum value.
%
disp (['Maximum value in ', DATASET,' is ' num2str(maxV)]);
disp (['Minimum value in ', DATASET,' is ' num2str(minV)]);

%
% Close and release resources.
%
H5P.close (dcpl);
H5D.close (dset);
H5F.close (file);

