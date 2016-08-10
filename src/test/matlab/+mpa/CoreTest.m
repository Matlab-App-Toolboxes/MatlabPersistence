classdef CoreTest < matlab.unittest.TestCase
    
    properties
        fixture
    end
    
    properties(Constant)
        TEST_FILE = 'test.h5';
    end
    
    methods(TestClassSetup)
        
        function setFixture(obj)
            obj.fixture = [fileparts(which('test.m')) filesep 'fixtures'];
            
            if exist(obj.fixture, 'file')
                rmdir(obj.fixture, 's');
            end
            mkdir(obj.fixture);
        end
        
    end
    
    methods(Test)
        
        function testGetPersistenceUnit(obj)
            entities = mpa.core.PersistenceUnit.ENTITIES;
            persistenceName = mpa.core.PersistenceUnit.PERSISTENCE_NAME;
            entitiesClazz =  {'entity.Basic', 'entity.IntensityMeasurement'};
            properties = {'local-path', 'remote-path', 'use-cache', 'create-mode', entities, persistenceName};
            values = {[obj.fixture filesep obj.TEST_FILE], '', 'false', 'true', entitiesClazz, 'patch-rig'};
            
            path = which('unknown.xml');
            obj.verifyError(@()mpa.core.Initializer(path), 'persistence:not:found');
            
            path = which('persistence.xml');
            i = mpa.core.Initializer(path);
            obj.verifyError(@()i.getPersistenceUnit('unknown'), 'MATLAB:Java:GenericException');
            
            % verify persistence unit
            unit = i.getPersistenceUnit('patch-rig');
            obj.verifyNotEmpty(unit);
            obj.verifyEqual(unit.name, 'patch-rig');
            obj.verifyEqual(unit.path, path);
            obj.verifyEqual(class(unit.provider), 'mpa.h5.H5MatlabProvider');
            obj.verifyEqual(unit.propertyMap, containers.Map(properties, values));
            
            % verify entity schema instance
            schema = unit.entitySchemaMap('entity.IntensityMeasurement');
            obj.verifyNotEmpty(schema);
            obj.verifyEqual(schema.class, 'entity.IntensityMeasurement');
            obj.verifyEqual(schema.dataManager, 'TestDataManager');
            
            % primary id comparison
            obj.verifyEqual(schema.id.name, 'id');
            obj.verifyEqual(schema.id.attributeType, 'string');
            obj.verifyEqual(class(schema.id.converter), 'mpa.util.DateTimeConverter');
            
            obj.verifyNumElements(schema.basics, 9)
            obj.verifyNumElements(schema.elementCollections, 4);
            
            % verify basic instance
            basic = schema.basics(1);
            obj.verifyEqual(basic.name, 'calibrationDate')
            obj.verifyEqual(basic.attributeType, 'string')
            
            % verify collection instance
            collection = schema.elementCollections(1);
            obj.verifyEqual(collection.name, 'voltages')
            obj.verifyEqual(collection.attributeType, 'double')
            
        end
        
        function testEntityManager(obj)
            em = mpa.factory.createEntityManager('patch-rig');
            obj.verifyNotEmpty(em);
           
            entity = struct();
            entity.string = 'test-string';
            entity.double = 1e-12;
            entity.int = 1;
            entity.id = 'id';
            entity.class = 'entity.Basic';
            em.persist(entity);
            
            pause(1);
            em.persist(entity);
            
            fname = [obj.fixture filesep obj.TEST_FILE];
            info = h5info(fname, '/entity_Basic');
            obj.verifyNumElements(info.Groups, 2);
            group = info.Groups(1).Name;
            
            query = struct('class', 'entity.Basic', 'id', 'id');
            date = mpa.util.DateTimeConverter.keyToDateTime(group);
            expected = em.find(query, date);
            
            obj.verifyEqual(expected.string, entity.string);
            obj.verifyEqual(expected.double, entity.double);
            obj.verifyEqual(expected.int, entity.int);
            obj.verifyEqual(expected.id, group);
            em.close();
        end
    end
    
end

