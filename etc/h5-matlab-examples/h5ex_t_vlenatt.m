function h5ex_t_vlenatt
%**************************************************************************
%
%  This example shows how to read and write variable-length
%  datatypes to an attribute.  The program first writes two
%  variable-length integer arrays to the attribute then
%  closes the file.  Next, it reopens the file, reads back
%  the data, and outputs it to the screen.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

fileName       = 'h5ex_t_vlenatt.h5';
DATASET        = 'DS1';
ATTRIBUTE      = 'A1';
LEN0           = 3;
%LEN1           = 12;

dims = 2;

%
% Initialize variable-length data.  wdata{1} is a countdown of
% length LEN0, wdata{2} is a Fibonacci sequence of length LEN1.
%
wdata{1} = int32(LEN0:-1:1);
wdata{2} = int32([ 1 1 2 3 5 8 13 21 34 55 89 144]);

%
%% Create a new file using the default properties.
%
file = H5F.create (fileName, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Create variable-length datatype for file and memory.
%
filetype = H5T.vlen_create ('H5T_STD_I32LE');
memtype = H5T.vlen_create ('H5T_NATIVE_INT');

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
space = H5S.create_simple (1,fliplr( dims), []);

%
% Create the attribute and write the variable-length data to it
%
attr = H5A.create (dset, ATTRIBUTE, filetype, space, 'H5P_DEFAULT');
H5A.write (attr, memtype, wdata);

%
% Close and release resources.
%
H5A.close (attr);
H5D.close (dset);
H5S.close (space);
H5T.close (filetype);
H5T.close (memtype);
H5F.close (file);

%
%% Now we begin the read section of this example.  Here we assume
% the attribute has the same name and rank, but can have any size.
%

%
% Open file, dataset, and attribute.
%
file = H5F.open (fileName, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
dset = H5D.open (file, DATASET);
attr = H5A.open_name (dset, ATTRIBUTE);

%
% Get dataspace
%
space = H5A.get_space (attr);
[~, dims, ~] = H5S.get_simple_extent_dims (space);

%
% Create the memory datatype.
%
memtype = H5T.vlen_create ('H5T_NATIVE_INT');

%
% Read the data.
%
rdata = H5A.read (attr, memtype);

%
% Output the variable-length data to the screen.
%
for i=1: dims(1)
    fprintf ('%s[%u]:\n  {',ATTRIBUTE,i);
    ptr = rdata{i};
    for j=1:length(rdata{i})
        fprintf (' %d', ptr(j));
        if ( (j+1) < length(rdata{i}) )
            fprintf (',');
        end
    end
    fprintf ('} \n');
end

%
% Close and release resources.
%
H5A.close (attr);
H5D.close (dset);
H5S.close (space);
H5T.close (memtype);
H5F.close (file);

