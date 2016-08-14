classdef CoreTest < matlab.unittest.TestCase
    
    properties
        fixture
    end
    
    properties(Constant)
        TEST_H5_FILE = 'test.h5';
        TEST_MAT_TABLE_FILE = 'test-table.mat'
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
            entitiesClazz =  {'entity.Basic',  'entity.Collections', 'entity.IntensityMeasurement'};
            properties = {'local-path', 'remote-path', 'use-cache', 'create-mode', entities, persistenceName};
            
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
            obj.verifyEqual(sort(unit.propertyMap.keys), sort(properties));
            actual = unit.propertyMap(entities);
            obj.verifyEqual(sort(actual.keys), sort(entitiesClazz));
            
            % verify entity schema instance
            schema = unit.entitySchemaMap('entity.IntensityMeasurement');
            obj.verifyNotEmpty(schema);
            obj.verifyEqual(schema.class, 'entity.IntensityMeasurement');
            obj.verifyEqual(schema.dataManager, 'TestDataManager');
            
            % primary id comparison
            obj.verifyEqual(schema.id.name, 'id');
            obj.verifyEqual(schema.id.field, 'mpa.fields.DateTime');
            obj.verifyEqual(schema.id.attributeType, 'string');
            
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
        
        function testH5Provider(obj)
            em = mpa.factory.createEntityManager('patch-rig');
            obj.verifyNotEmpty(em);
            
            % test basic
            expected = struct();
            expected.string = 'test-string';
            expected.double = 1e-12;
            expected.int = 1;
            expected.id = 'id';
            expected.class = 'entity.Basic';
            
            em.persist(expected);
            
            pause(1);
            em.persist(expected);
            
            fname = [obj.fixture filesep obj.TEST_H5_FILE];
            info = h5info(fname, '/entity_Basic');
            
            obj.verifyNumElements(info.Groups, 2);
            group = info.Groups(1).Name;
            field = mpa.fields.DateTime(group);
            
            dateTime = strsplit(datestr(field.time), ' ');
            actualDate = dateTime{1};
            obj.verifyEqual(actualDate, datestr(date))
            
            query = struct('class', 'entity.Basic', 'id', field.key);
            actual = em.find(query);
            obj.verifyEqual(actual.string, expected.string);
            obj.verifyEqual(actual.double, expected.double);
            obj.verifyEqual(actual.int, expected.int);
            obj.verifyEqual(actual.id, group);
            
            
            % test collections
            expected = struct();
            expected.strings = {'one'; 'two'; 'three'};
            expected.doubles = [1e-9; 1e-10; 1e-11];
            expected.ints = int32([1; 2; 3]);
            expected.id = 'id';
            expected.class = 'entity.Collections';
            em.persist(expected);
            
            info = h5info(fname, '/entity_Collections');
            group = info.Groups(1).Name;
            
            field = mpa.fields.DateTime(group);
            dateTime = strsplit(datestr(field.time), ' ');
            actualDate = dateTime{1};
            obj.verifyEqual(actualDate, datestr(date))
            
            query = struct('class', 'entity.Collections', 'id', field.key);
            actual = em.find(query);
            
            obj.verifyEqual(actual.strings, expected.strings);
            obj.verifyEqual(actual.doubles, expected.doubles);
            obj.verifyEqual(actual.ints, expected.ints);
            obj.verifyEqual(actual.id, group);
            
            em.close();
        end
        
        function testSimpleProvider(obj)
            em = mpa.factory.createEntityManager('patch-rig-log');
            obj.verifyNotEmpty(em);
            
            expected = struct();
            expected.string = 'test-string';
            expected.double = 1e-12;
            expected.integer = 1;
            expected.class = 'entity.TestTable';
            expected.doubleArray = 1 : 5;
            expected.stringArray = {'one', 'twu', 'three'};
            expected.id = [];
            em.persist(expected);
            
            query = struct('class', 'entity.TestTable', 'id', []);
            actual = em.find(query);
            obj.verifyEqual(actual.id, 1);
            obj.verifyEqual(actual.string{1}, expected.string);
            obj.verifyEqual(actual.double, expected.double);
            obj.verifyEqual(actual.integer, expected.integer);
            obj.verifyEqual(actual.integer, expected.integer);
            obj.verifyEqual(actual.doubleArray, expected.doubleArray);
            obj.verifyEqual(actual.stringArray, expected.stringArray);
            
            em.close();
        end
    end
    
end

