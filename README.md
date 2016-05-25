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
-  Add the JitPack repository to your build file
```
	<repositories>
		<repository>
		    <id>jitpack.io</id>
		    <url>https://jitpack.io</url>
		</repository>
	</repositories>
```
- Add the dependency
``` <mpa.version>2f8dea9523</mpa.version> ```

```
	<dependency>
	    <groupId>com.github.ragavsathish</groupId>
	    <artifactId>matlab-hdf5-persistence</artifactId>
	    <version>${mpa.version}</version>
	</dependency>

```
## Usage Instructions 

[Wiki](https://github.com/ragavsathish/matlab-hdf5-persistence/wiki)

License MIT
