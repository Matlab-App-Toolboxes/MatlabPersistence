function h5ex_t_bit
%**************************************************************************
%
%  This example shows how to read and write bitfield
%  datatypes to a dataset.  The program first writes bit
%  fields to a dataset with a dataspace of DIM0xDIM1, then
%  closes the file.  Next, it reopens the file, reads back
%  the data, and outputs it to the screen.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

fileName       = 'h5ex_t_bit.h5';
DATASET        = 'DS1';
DIM0           = 4;
DIM1           = 7;

dims  = [DIM0 DIM1];
wdata = uint8(zeros(dims));

%
% Initialize data.  We will manually pack 4 2-bit integers into
% each unsigned char data element.
%
for i=1: DIM0
    for j=1: DIM1
        ii=i-1;
        jj=j-1;
        wdata(i,j) = 0;
        % Field 'A' %
        wdata(i,j) = bitor(wdata(i,j), bitand(uint8((ii * jj - jj)), 3));
        % Field 'B' %
        wdata(i,j) = bitor(wdata(i,j), bitshift(bitand(ii, 3), 2));
        % Field 'C' %
        wdata(i,j) = bitor(wdata(i,j), bitshift(bitand(jj, 3), 4));
        % Field 'D' %
        wdata(i,j) = bitor(wdata(i,j), bitshift(bitand((ii + jj), 3),6));
    end
end

%
%% Create a new file using the default properties.
%
file = H5F.create (fileName, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Create dataspace.  Setting maximum size to [] sets the maximum
% size to be the current size.
%
space = H5S.create_simple (2,fliplr( dims), []);

%
% Create the dataset and write the bitfield data to it.
%
dset = H5D.create (file, DATASET,'H5T_STD_B8BE',space,'H5P_DEFAULT');
H5D.write (dset, 'H5T_NATIVE_B8','H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT',wdata);

%
% Close and release resources.
%
H5D.close (dset);
H5S.close (space);
H5F.close (file);


%
%% Now we begin the read section of this example.  Here we assume
% the dataset has the same name and rank, but can have any size.


%
% Open file and dataset.
%
file = H5F.open (fileName, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
dset = H5D.open (file, DATASET);

%
% Get dataspace and allocate memory for read buffer.  This is a
% two dimensional dataset so the dynamic allocation must be done
% in steps.
%
space = H5D.get_space (dset);
[~, dims, ~] = H5S.get_simple_extent_dims(space);
dims=fliplr(dims);

%
% Read the data.
%
rdata =H5D.read (dset,'H5T_NATIVE_B8', 'H5S_ALL', 'H5S_ALL', 'H5P_DEFAULT');

% Reduce to a 2D matrix
rdata=squeeze(rdata);

%
% Output the data to the screen.
%
fprintf ('%s:\n', DATASET);
for i=1: dims(1)
    fprintf (' [');
    for j=1: dims(2)
        A = bitand(rdata(i,j),03);               % Retrieve field 'A' %
        B = bitand(bitshift(rdata(i,j),-2),03);  % Retrieve field 'B' %
        C = bitand(bitshift(rdata(i,j),-4),03);  % Retrieve field 'C' %
        D = bitand(bitshift(rdata(i,j),-6),03);  % Retrieve field 'D' %
        fprintf (' {%d, %d, %d, %d} ', A, B, C, D);
    end
    fprintf (' ]\n');
end

%
% Close and release resources.
%
H5D.close (dset);
H5S.close (space);
H5F.close (file);

