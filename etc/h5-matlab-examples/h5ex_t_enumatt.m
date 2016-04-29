function h5ex_t_enumatt
%**************************************************************************
%
% This example shows how to read and write enumerated
% datatypes to an attribute.  The program first writes
% enumerated values to an attribute with a dataspace of
% DIM0xDIM1, then closes the file.  Next, it reopens the
% file, reads back the data, and outputs it to the screen.
%
% This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

fileName       = 'h5ex_t_enumatt.h5';
DATASET        = 'DS1';
ATTRIBUTE      = 'A1';
DIM0           = 4;
DIM1           = 7;

dims =[DIM0, DIM1];
wdata=int32(zeros(dims));
% Mimic enums
names={'SOLID', 'LIQUID', 'GAS', 'PLASMA'};
values=[ 1 2 3 4];
SOLID =1;
%LIQUID=2;
%GAS   =3;
PLASMA=4;

%
% Initialize data.
%
for i=1: DIM0
    for j=1: DIM1
        ii=i-1;
        jj=j-1;
        wdata(i,j) =  mod(((ii + 1)* jj - jj) , PLASMA) + 1;
    end
end

%
%% Create a new file using the default properties.
%
file = H5F.create (fileName, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Create the enumerated datatypes for file and memory.  This
% process is simplified if native types are used for the file,
% as only one type must be defined.
%
filetype = H5T.enum_create ('H5T_NATIVE_INT');
memtype  = H5T.enum_create ('H5T_NATIVE_INT');

for i = SOLID:PLASMA
    %
    % Insert enumerated value for memtype.
    %
    H5T.enum_insert (memtype, names{i}, values(i));
    %
    H5T.enum_insert (filetype, names{i}, values(i));
    
end

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
space = H5S.create_simple (2,fliplr( dims), []);

%
% Create the attribute and write the enumerated data to it.
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
[~, dims,~] = H5S.get_simple_extent_dims (space);
dims=fliplr(dims);

%
% Read the data.
%
rdata=H5A.read (attr, memtype);

%
% Output the data to the screen.
%
fprintf ('%s:\n', ATTRIBUTE);
for i=1: dims(1)
    fprintf (' [');
    for j=1: dims(2)
        
        %
        % Get the name of the enumeration member.
        %
        name=H5T.enum_nameof (memtype, rdata(i,j));
        fprintf (' %-6s', name);
    end
    fprintf (']\n');
end

%
% Close and release resources.
%
H5A.close (attr);
H5D.close (dset);
H5S.close (space);
H5T.close (memtype);
H5F.close (file);

