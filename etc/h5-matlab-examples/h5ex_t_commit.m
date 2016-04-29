function h5ex_t_commit
%**************************************************************************
%
%  This example shows how to commit a named datatype to a
%  file, and read back that datatype.  The program first
%  defines a compound datatype, commits it to a file, then
%  closes the file.  Next, it reopens the file, opens the
%  datatype, and outputs the names of its fields to the
%  screen.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

fileName       = 'h5ex_t_commit.h5';
DATATYPE       = 'Sensor_Type';

%
%% Create a new file using the default properties.
%
file = H5F.create (fileName, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');


%
%Create the required data types
%
intType   =H5T.copy('H5T_NATIVE_INT');
sz(1)     =H5T.get_size(intType);
strType   = H5T.copy ('H5T_C_S1');
H5T.set_size (strType, 'H5T_VARIABLE');
sz(2)     =H5T.get_size(strType);
doubleType=H5T.copy('H5T_NATIVE_DOUBLE');
sz(3)     =H5T.get_size(doubleType);
doubleType=H5T.copy('H5T_NATIVE_DOUBLE');
sz(4)     =H5T.get_size(doubleType);


%
% Computer the offsets to each field. The first offset is always zero.
%
offset(1)=0;
offset(2:4)=cumsum(sz(1:3));


%
% Create the compound datatype.  Because the standard types we are
% using may have different sizes than the corresponding native
% types, we must manually calculate the offset of each member.
%
filetype = H5T.create ('H5T_COMPOUND', sum(sz));
H5T.insert (filetype, 'serial_no', offset(1),intType);
H5T.insert (filetype, 'location', offset(2), strType);
H5T.insert (filetype, 'temperature',offset(3), doubleType);
H5T.insert (filetype, 'pressure',offset(4), doubleType);

%
% Commit the compound datatype to the file, creating a named
% datatype.
%
H5T.commit (file, DATATYPE, filetype);

%
% Close and release resources.
%
H5T.close (filetype);
H5F.close (file);


%
%% Now we begin the read section of this example.
%

%
% Open file.
%
file = H5F.open (fileName, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');

%
% Open the named datatype.
%
filetype = H5T.open (file, DATATYPE);

%
% Output the data to the screen.
%
fprintf ('Named datatype: %s:\n', DATATYPE);

%
% Get datatype class.  If it isn't compound, we won't print
% anything.
%
typeclass = H5T.get_class (filetype);
if typeclass == H5ML.get_constant_value('H5T_COMPOUND')
    fprintf ('   Class: H5T_COMPOUND\n');
    nmembs = H5T.get_nmembers (filetype);
    
    %
    % Iterate over compound datatype members.
    %
    for i=1: nmembs
        %
        % Get the member name and print.
        %
        name = H5T.get_member_name (filetype, i-1);
        fprintf ('   %s\n', name);
    end
end

%
% Close and release resources.
%
H5T.close (filetype);
H5F.close (file);




