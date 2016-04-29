function h5ex_g_visit
%**************************************************************************
%  This example shows how to recursively traverse a file
%  using H5O.visit and H5L.visit.  The program prints all of
%  the objects in the file specified in FILE, then prints all
%  of the links in that file.  The default file used by this
%  example implements the structure described in the User's
%  Guide, chapter 4, figure 26.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************

FILE =       'h5ex_g_visit.h5';

%
% Open file
%
file = H5F.open (FILE, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');

%
% Begin iteration using H5O.visit
%
disp ('Objects in the file:');
H5O.visit (file, 'H5_INDEX_NAME', 'H5_ITER_NATIVE',@op_func, []);

%
% Repeat the same process using H5L.visit
%
disp ('Links in the file:');
H5L.visit (file, 'H5_INDEX_NAME', 'H5_ITER_NATIVE',@op_func_L, []);

%
% Close and release resources.
%
H5F.close (file);


end


function [status opdataOut]=op_func(rootId,name,~)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Operator function for H5O.visit.  This function prints the
%name and type of the object passed to it.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('/');               % Print root group in object path %

objId=H5O.open(rootId,name,'H5P_DEFAULT');
info=H5O.get_info(objId);
H5O.close(objId);
%
% Check if the current object is the root group, and if not print
% the full path name and type.
%
if (name(1) == '.')         % Root group, do not print '.' %
    fprintf ('  (Group)\n');
else
    switch (info.type)
        case H5ML.get_constant_value('H5O_TYPE_GROUP')
            disp ([name ' (Group)']);
            
        case H5ML.get_constant_value('H5O_TYPE_DATASET')
            disp ([name ' (Dataset)']);
            
        case H5ML.get_constant_value('H5O_TYPE_NAMED_DATATYPE')
            disp ([name ' (Datatype)']);
            
        otherwise
            disp ([name '  (Unknown)']);
    end
    
end


opdataOut=[];
status=0;
end

function [status opdataOut]=op_func_L(gid,name,opdataIn)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%Operator function for H5L.visit.  This function simply
%retrieves the info for the object the current link points
%to, and calls the operator function for H5O.visit.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
% Get type of the object and display its name and type.
% The name of the object is passed to this function by
% the Library.
%
status=0;
opdataOut=[];
op_func (gid,name,opdataIn);
end

