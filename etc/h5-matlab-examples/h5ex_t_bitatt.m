function h5ex_t_bitatt
%**************************************************************************
%
%  This example shows how to read and write bitfield
%  datatypes to an attribute.  The program first writes bit
%  fields to an attribute with a dataspace of DIM0xDIM1, then
%  closes the file.  Next, it reopens the file, reads back
%  the data, and outputs it to the screen.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

fileName       = 'h5ex_t_bitatt.h5';
DATASET        = 'DS1';
ATTRIBUTE      = 'A1';
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
% Create dataset with a scalar dataspace.
%
space = H5S.create ('H5S_SCALAR');
dset = H5D.create (file, DATASET, 'H5T_STD_I32LE', space, 'H5P_DEFAULT');
H5S.close (space);

%
% Create dataspace.  Setting maximum size to [] sets the maximum
% size to be the current size.
%
space = H5S.create_simple (2,fliplr(dims), []);

%
% Create the attribute and write the bitfield data to it.
%
attr = H5A.create (dset, ATTRIBUTE,'H5T_STD_B8BE', space,'H5P_DEFAULT');
H5A.write (attr,'H5T_NATIVE_B8', wdata);

%
% Close and release resources.
%
H5A.close (attr);
H5D.close (dset);
H5S.close (space);
H5F.close (file);

%
%% Now we begin the read section of this example.  Here we assume
% the attribute has the same name and rank, but can have any size.

%
% Open file, dataset, and attribute.
%
file = H5F.open (fileName, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
dset = H5D.open (file, DATASET);
attr = H5A.open_name (dset, ATTRIBUTE);

%
% Get dataspace and allocate memory for read buffer.
%
space = H5A.get_space (attr);
[~, dims, ~] = H5S.get_simple_extent_dims (space);
dims=fliplr(dims);

%
% Read the data.
%
rdata=H5A.read (attr, 'H5T_NATIVE_B8');
% Convert from 1xdims(1)xdims(2) to dims(1)xdims(2)
rdata=squeeze(rdata);
%
% Output the data to the screen.
%
fprintf ('%s:\n', ATTRIBUTE);
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
H5A.close (attr);
H5D.close (dset);
H5S.close (space);
H5F.close (file);

