# Matlab HD5 Persistance

The Matlab HD5 Persistance is used for 
	- accessing
	- persisting
	- managing 
	- data between Matlab objects / structures and a HDF5 file

It tries to mimick [Java Persistence API](http://openjpa.apache.org/builds/1.2.3/apache-openjpa/docs/jpa_overview_arch.html) functionality. It follows [maven](https://maven.apache.org/) build life cycle customized for matlab. Sample matlab maven archetype can be found in [link](https://github.com/ragavsathish/matlab-simple-archetype). 

Dependcies are lookup from [jitpack.io](https://jitpack.io) 

## Usage instructions 

1. Create customized MyPersistence.m which inherits from io.matlab.persistence
	
	```
	classdef MyPersistence < io.mpa.Persistence
	    enumeration
	    end
	end
	```
2. To add simple attribute based HDF mapping follow below where __SIMPLE_ENTITY_ATTR__ is group in hdf5 file

	```	
	classdef MyPersistence < io.mpa.Persistence
	    enumeration

	        SIMPLE_ENTITY_ATTR([...
	            io.mpa.H5DataType.SIMPLE_INTEGER_ATTR.map('integer') ...
	            io.mpa.H5DataType.SIMPLE_STRING_ATTR.map('string') ...
	            io.mpa.H5DataType.SIMPLE_DOUBLE_ATTR.map('double') ...
	            ])

	```

3. Associate Mypersistence.m with Entity classes

	```
	classdef SimpleEntityAttr < io.mpa.H5Entity
	    
	    properties
	      	entityIdentifier = MyPersistence.SIMPLE_ENTITY_ATTR
	    end

	    properties
	    	integer
	    	string
	    	double
	    	identifier
	    end
	   
	    methods
	        
	        function obj = SimpleEntityAttr(id)
	            obj.identifier = id;
	        end
	    end
	end
	```
4. Create h5properties.json to describe about location of hdf file and unique identifier.
	
	```

	{
		"persistence": "Mypersistence",

		"location": [
			{
				"id": "some_id",
				"description": "description about hdf5 file",
				"local_path": "src/test/resources/test.h5",
				"remotepath": ""
			}
	}
	```
5. Create an entity manager instance ``` entityManager =  io.mpa.persistence.createEntityManager("some_id", "h5properties.json"); ```

6. To persist (or) save a class of value into HDF5 attributes with group path being __SIMPLE_ENTITY_ATTR__.

	```
		em = obj.entityManager;
        entity = SimpleEntityAttr('simple');
        entity.integer = int32(10);
        entity.double = 5.1;
        entity.string = 'abc';

        em.persist(entity);
	``` 

7. To query from hdf5 for path 	__SIMPLE_ENTITY_ATTR__.

	``` 
		entity = SimpleEntityAttr('simple');
		em.find(entity);
		
	```