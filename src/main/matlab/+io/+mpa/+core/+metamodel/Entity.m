classdef Entity < handle

    properties(Access = private)
    	jEntity
	end

	properties(SetAccess = private)
        basics
        elementCollections
	end

    properties(Dependent)
        class
        prePersist
        postPersist
        postLoad
        id
    end
    
    methods

    	function obj = Entity(jEntity)
    		obj.jEntity = jEntity;
    		obj.populateAttributes();
    	end

    	function class = get.class(obj)
    		class = obj.jEntity.getClazz();
    	end

    	function h = get.prePersist(obj)
    		h = obj.jEntity.getPrePersist().methodName();
    	end

    	function h = get.postPersist(obj)
    		h = obj.jEntity.getPostPersist().methodName();
    	end

    	function h = get.postLoad(obj)
    		h = obj.jEntity.getPostLoad().methodName();
    	end

    	function id = get.id(obj)
    		id = obj.jEntity.getAttributes().getId().get(0);
    	end
    end

    methods(Access = private)

    	function populateAttributes(obj)
    		import io.mpa.core.metamodel.*;

    		jList = obj.jEntity.getAttributes().getBasicCollection();
			obj.basics = Basic.empty(0, jList.size());
			jIterator = jList.iterator;

			idx = 1;
			while jIterator.hasNext()
				obj.basics(idx) = Basic(jIterator.next());
				idx = idx + 1;
			end

			jList = obj.jEntity.getAttributes().getElementCollection();
			obj.elementCollections = ElementCollection.empty(0, jList.size());

			idx = 1;
			while jIterator.hasNext()
				obj.elementCollections(idx) = ElementCollection(jIterator.next());
				idx = idx + 1;
			end
    	end
	end
end