function h5ex_g_corder
%**************************************************************************
%
%
%  This example shows how to track links in a group by
%  creation order.  The program creates a series of groups,
%  then reads back their names: first in alphabetical order,
%  then in creation order. This example uses H5L.iterate.
%
%  This example needs files updated in bug report ID 576851. 
%  Please visit http://www.mathworks.com/support/bugreports/ to search for
%  the bug report and download the updated files.
%
%  This file is intended for use with HDF5 Library version 1.8
%
%**************************************************************************

FILE =       'h5ex_g_corder.h5';

%
%% Create a new file using the default properties.
%
file = H5F.create (FILE, 'H5F_ACC_TRUNC', 'H5P_DEFAULT', 'H5P_DEFAULT');

%
% Create group creation property list and enable link creation
% order tracking.  Attempting to track by creation order in a
% group that does not have this property set will result in an
% error.
%
gcpl = H5P.create ('H5P_GROUP_CREATE');

crtOrder=bitor(...
    H5ML.get_constant_value('H5P_CRT_ORDER_TRACKED'), ...
    H5ML.get_constant_value('H5P_CRT_ORDER_INDEXED'));

%Please refer the bug report for H5P.set_link_creation here:

H5P.set_link_creation_order( gcpl, crtOrder );

%
% Create primary group using the property list.
%
group = H5G.create (file, 'index_group',...
    'H5P_DEFAULT', gcpl, 'H5P_DEFAULT');

%
% Create subgroups in the primary group.  These will be tracked
% by creation order.  Note that these groups do not have to have
% the creation order tracking property set.
%
subgroup = H5G.create (group, 'H', ...
    'H5P_DEFAULT', 'H5P_DEFAULT', 'H5P_DEFAULT');
H5G.close (subgroup);
subgroup = H5G.create (group, 'D', ...
    'H5P_DEFAULT', 'H5P_DEFAULT', 'H5P_DEFAULT');
H5G.close (subgroup);
subgroup = H5G.create (group, 'F', ...
    'H5P_DEFAULT', 'H5P_DEFAULT', 'H5P_DEFAULT');
H5G.close (subgroup);
subgroup = H5G.create (group, '5', ...
    'H5P_DEFAULT', 'H5P_DEFAULT', 'H5P_DEFAULT');
H5G.close (subgroup);

%
% Get group info.
%
%ginfo=H5G.get_info (group);

%
% Traverse links in the primary group using alphabetical indices
% (H5_INDEX_NAME).
%
disp('Traversing group using alphabetical indices:');
H5L.iterate(group,'H5_INDEX_NAME','H5_ITER_INC',0,@iterFunc,1);

%
% Traverse links in the primary group by creation order
% (H5_INDEX_CRT_ORDER).
%
disp('Traversing group using creation order indices:');
H5L.iterate(group,'H5_INDEX_CRT_ORDER','H5_ITER_INC',0,@iterFunc,1);
%
% Close and release resources.
%
H5P.close (gcpl);
H5G.close (group);
H5F.close (file);


end

function [status index_out] = iterFunc(~,name,index_in)

disp(['Index ', num2str(index_in),': ',name]);
status=0;
index_out=index_in+1;
end
