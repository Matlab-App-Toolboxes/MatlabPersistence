# Matlab HD5 Persistence

The Matlab HD5 Persistence is used for 
	- accessing
	- persisting
	- managing 
	- data between Matlab objects / structures and a HDF5 file

It tries to mimic [Java Persistence API](http://openjpa.apache.org/builds/1.2.3/apache-openjpa/docs/jpa_overview_arch.html) functionality. It follows [maven](https://maven.apache.org/) build life cycle customized for matlab. Sample matlab maven archetype can be found in [link](https://github.com/ragavsathish/matlab-simple-archetype). 

Dependencies are looked up from [jitpack.io](https://jitpack.io) 

## Development

1. Download and install maven from [Apache maven](https://maven.apache.org/index.html)
2. Make sure ```  mvn -verison ``` gives the jdk and maven path
3. git clone https://github.com/ragavsathish/matlab-hdf5-persistence.git
4. cd matlab-hdf5-persistence
5. ``` mvn clean compile ``` should download necessary dependency. 

We are good to go with developemet 

## Dependency Information

1. Add the JitPack repository to your build file

```
	<repositories>
		<repository>
		    <id>jitpack.io</id>
		    <url>https://jitpack.io</url>
		</repository>
	</repositories>
```

2. Add the dependency

``` <mpa.version>2f8dea9523</mpa.version> ````

```
	<dependency>
	    <groupId>com.github.ragavsathish</groupId>
	    <artifactId>matlab-hdf5-persistence</artifactId>
	    <version>${mpa.version}</version>
	</dependency>

```

## Usage instructions 

1. Create customized MyPersistence.m which inherits from io.matlab.persistence
	
	```matlab
	classdef MyPersistence < io.mpa.Persistence
	    enumeration
	    end
	end
	```
2. To add __SIMPLE_ENTITY_ATTR__  as attribute group in HDF.

	```matlab	
	classdef MyPersistence < io.mpa.Persistence
	    enumeration

	        SIMPLE_ENTITY_ATTR([...
	            io.mpa.H5DataType.SIMPLE_INTEGER_ATTR.map('integer') ...
	            io.mpa.H5DataType.SIMPLE_STRING_ATTR.map('string') ...
	            io.mpa.H5DataType.SIMPLE_DOUBLE_ATTR.map('double') ...
	            ])

	```

3. Link MyPersistence.SIMPLE_ENTITY_ATTR to entity class

	```matlab
	classdef SimpleEntityAttr < io.mpa.H5Entity
	    
	    properties
	    	group
	      	entityId = MyPersistence.SIMPLE_ENTITY_ATTR
	    end

	    properties
	    	integer
	    	string
	    	double
	    end
	   
	    methods
	        
	        function obj = SimpleEntityAttr(id)
	            obj = obj@io.mpa.H5Entity(id);
	        end
	    end
	end
	```
4. Create h5properties.json to describe about location of hdf file with some unique identifier.
	
	```json

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

6. To persist (or) save a class of value into HDF5 attributes 

	```matlab
		em = obj.entityManager;
        entity = SimpleEntityAttr('simple');
        entity.integer = int32(10);
        entity.double = 5.1;
        entity.string = 'abc';

        em.persist(entity);
	``` 

7. To query hdf5 from path 	__SIMPLE_ENTITY_ATTR__.

	```matlab
		entity = SimpleEntityAttr('simple');
		em.find(entity);

	```
