classdef EntityManagerFactory < handle

	properties(SetAccess = 'private')
		h5json
		persistenceContext
	end

	methods

		function obj = EntityManagerFactory(fname)
			 obj.h5json = loadjson(fname);
			 obj.persistenceContext = containers.Map();
		end

		function em = create(obj, id)

			if isKey(obj.persistenceContext, id)
				em = obj.persistenceContext(id);
			end

		    h5Properties = obj.h5json.location;

		    for i = 1:numel(h5Properties)
		        
		        if strcmp(h5Properties{i}.id, id)
		            fname = h5Properties{i}.local_path;
		            persistence = h5Properties{i}.persistence;
		            break;
		        end
		    end

		    if isempty(fname)
		        throw(MException('MATLAB:LoadErr', 'local_path is empty'));
		    end

		    p = enumeration(persistence);

		    if isempty(p)
		        throw(MException('MATLAB:LoadErr', ['Unable to find ' persistence '.m in matlab path' ]));
		    end

		    entites = p.entities;
		    entityMap = containers.Map();
		    
		    for i = 1 :numel(entites)
		        e = entites(i);
		        entityMap(char(e)) = e;
		    end
		    em = io.mpa.H5EntityManager(fname, entityMap);
		    obj.persistenceContext(id) = em;
		end
	end
end