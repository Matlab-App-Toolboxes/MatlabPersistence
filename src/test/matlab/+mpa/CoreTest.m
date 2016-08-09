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
        end
        
    end
    
    methods(Test)
        
        function testGetPersistenceUnit(obj)
            entities = mpa.core.PersistenceUnit.ENTITIES;
            
            properties = {'local-path', 'remote-path', 'use-cache', 'create-mode', entities};
            values = {[obj.fixture filesep obj.TEST_FILE], '', 'false', 'true', {'entity.IntensityMeasurement'}};
            
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
            
            obj.verifyEqual(numel(schema.basics), 9)
            obj.verifyEqual(numel(schema.elementCollections), 4);
            
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
            entity = mpa.factory.createEntityManager('patch-rig');
            obj.verifyNotEmpty(entity);
        end
    end
    
end

