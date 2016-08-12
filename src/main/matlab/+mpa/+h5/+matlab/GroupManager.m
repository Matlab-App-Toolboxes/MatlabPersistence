classdef GroupManager < handle
    
    properties
        fname
    end
    
    methods
        
        function obj = GroupManager(fname)
            obj.fname = fname;
        end
        
        function tf = hasGroup(obj, path)
            try
                fid = H5F.open(obj.fname, 'H5F_ACC_RDONLY', 'H5P_DEFAULT');
                
                % Get type of the object and display its name and type.
                % The path of the object is passed to this function by
                statbuf = H5G.get_objinfo (fid, path, 0);
                tf = statbuf.type == H5ML.get_constant_value('H5G_GROUP');
            catch Me
                tf = strfind(Me.message, [' ' path ' doesn''t exist']) < 1;
            end
            H5F.close(fid);
        end
        
        function createGroup(obj, path)
            if obj.hasGroup(path)
                return
            end
            fid = H5F.open(obj.fname, 'H5F_ACC_RDWR', 'H5P_DEFAULT');
            
            % Create group creation property list and set it to allow creation
            % of intermediate groups.
            
            gcpl = H5P.create ('H5P_LINK_CREATE');
            H5P.set_create_intermediate_group (gcpl, 1);
            
            % Create the group /G1/G2/G3.  Note that /G1 and /G1/G2 do not
            % exist yet.  This call would cause an error if we did not use the
            % previously created property list.
            
            group = H5G.create (fid, path, gcpl, 'H5P_DEFAULT', 'H5P_DEFAULT');
            
            % Close and release resources.
            H5P.close (gcpl);
            H5G.close (group);
            H5F.close (fid);
        end
        
        function close(obj)
            delete(obj);
        end
    end
    
end

