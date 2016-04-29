function h5ex_g_iterate
%**************************************************************************
%
%  This example shows how to iterate over group members using
%  H5Giterate.
%
%  This file is intended for use with HDF5 Library version 1.8
%**************************************************************************
fileName      = 'h5ex_g_iterate.h5';

%
% Open file.
%
file = H5F.open (fileName, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');

%
% Begin iteration.
%
fprintf ('Objects in root group:\n');

H5G.iterate (file, '/',[] , @op_func);

%
% Close and release resources.
%
H5F.close (file);

end


%**************************************************************************
%
% Operator function.  Prints the name and type of the object
% being examined.
%
%**************************************************************************
function status=op_func (loc_id, name)

%
% Get type of the object and display its name and type.
% The name of the object is passed to this function by
% the Library.
%
statbuf=H5G.get_objinfo (loc_id, name, 0);

switch (statbuf.type)
    case H5ML.get_constant_value('H5G_GROUP')
        fprintf ('  Group: %s\n', name);
        
    case H5ML.get_constant_value('H5G_DATASET')
        fprintf ('  Dataset: %s\n', name);
        
    case H5ML.get_constant_value('H5G_TYPE')
        fprintf ('  Datatype: %s\n', name);
        
    otherwise
        fprintf ( '  Unknown: %s\n', name);
end

status=0;

end

