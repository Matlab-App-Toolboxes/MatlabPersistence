classdef H5EntityManagerTest < matlab.unittest.TestCase
    
    properties(Constant)
        ID = 'A'
        
    end
    
    properties
        entityManager
    end
    
    methods
        function obj = H5EntityManagerTest()
            
            h5Properties = which('test-h5properties.json');
            obj.entityManager =  io.mpa.persistence.createEntityManager(obj.ID, h5Properties);
        end
    end
    
    methods (TestMethodSetup)
        
        function methodSetup(obj)
            % Do Noting
        end
    end
    
    methods (TestMethodTeardown)
        
        function methodTeardown(obj)
            if exist(obj.entityManager.fname, 'file')
                delete(obj.entityManager.fname);
            end
        end
    end
    
    methods(Test)
        
        function testCreateEntityManager(obj)
            em = obj.entityManager;
            obj.verifyNotEmpty(em.fname);
            [e, d] = enumeration('TestPersistence');
            obj.verifyEqual(em.entityMap.keys, sort(d'));
            obj.verifyEqual(numel(em.entityMap.values), numel(e'));
        end
        
        
        function testComplexEntity(obj)
            em = obj.entityManager;
            
            expected = entity.ComplexEntity('complex');
            expected.integer = int32(10);
            expected.double = 5.1;
            expected.string = 'abc';
            
            expected.integersDs = int32([10; 20; 30; 40]);
            expected.doublesDs = [5.1; 10.1; 20.1; 40.1];
            expected.stringsDs = {'abc'; 'def'; 'ghi'; 'jkl' };
            
            expected.integersAttr = int32([10; 20; 30; 40]);
            expected.doublesAttr = [5.1; 10.1; 20.1; 40.1];
            expected.stringsAttr = {'abc'; 'def'; 'ghi'; 'jkl' };
            
            expected.extendedStruct.doubleDsOne =  expected.doublesDs;
            expected.extendedStruct.doubleDsTwo = 2.*  expected.doublesDs;
            expected.extendedStruct.doubleDsThree = 3.*  expected.doublesDs;
            em.persist(expected);
            
            actual = entity.ComplexEntity('complex');
            em.find(actual);
            
            obj.verifyEqual(actual.integer, expected.integer);
            obj.verifyEqual(actual.double, expected.double);
            obj.verifyEqual(actual.string, expected.string);
            
            obj.verifyEqual(actual.integersDs, expected.integersDs);
            obj.verifyEqual(actual.doublesDs, expected.doublesDs);
            obj.verifyEqual(actual.stringsDs, expected.stringsDs);
            
            obj.verifyEqual(actual.integersAttr, expected.integersAttr);
            obj.verifyEqual(actual.doublesAttr, expected.doublesAttr);
            obj.verifyEqual(actual.stringsAttr, expected.stringsAttr);
            obj.verifyEqual(actual.extendedStruct, expected.extendedStruct);
        end
        
        function testEntities(obj)
            em = obj.entityManager;
            
            expected = entity.SimpleEntityAttr('simple_entity');
            expected.integer = int32(10);
            expected.double = 5.1;
            expected.string = 'abc';
            
            em.persist(expected);
            actual = entity.SimpleEntityAttr('simple_entity');
            em.find(actual);
            
            obj.verifyEqual(actual.integer, expected.integer);
            obj.verifyEqual(actual.double, expected.double);
            obj.verifyEqual(actual.string, expected.string);
            
            expected = entity.CompoundEntityAttr('compound_entity');
            expected.integers = int32([10; 20; 30; 40]);
            expected.doubles = [5.1; 10.1; 20.1; 40.1];
            expected.strings = {'abc'; 'def'; 'ghi'; 'jkl' };
            
            em.persist(expected);
            actual = entity.CompoundEntityAttr('compound_entity');
            em.find(actual);
            
            obj.verifyEqual(actual.integers, expected.integers);
            obj.verifyEqual(actual.doubles, expected.doubles);
            obj.verifyEqual(actual.strings, expected.strings);
            
            expected = entity.CompoundEntityDS('compound_entity_ds');
            expected.integers = int32([10; 20; 30; 40]);
            expected.doubles = [5.1; 10.1; 20.1; 40.1];
            expected.strings = {'abc'; 'def'; 'ghi'; 'jkl' };
            em.persist(expected);
            
            actual = entity.CompoundEntityDS('compound_entity_ds');
            
            em.find(actual);
            obj.verifyEqual(actual.integers, expected.integers);
            obj.verifyEqual(actual.doubles, expected.doubles);
            obj.verifyEqual(actual.strings, expected.strings);
        end
        
        function testExecuteQuery(obj)
            em = obj.entityManager;
            expected = entity.SimpleEntityAttr('simple_entity_one');
            expected.integer = int32(10);
            expected.double = 5.1;
            expected.string = 'abc';
            expected.dateString = '19-May-2016';
            em.persist(expected);
            
            expected = entity.SimpleEntityAttr('simple_entity_two');
            expected.integer = int32(10);
            expected.double = 5.1;
            expected.string = 'abc';
            expected.dateString = '18-May-2016';
            em.persist(expected);
            
            expected = entity.SimpleEntityAttr('simple_entity_three');
            expected.integer = int32(10);
            expected.double = 5.1;
            expected.string = 'def';
            expected.dateString = '17-May-2016';
            em.persist(expected);
            
            actual = entity.SimpleEntityAttr('simple_entity');
            query = actual.getAllKeys();
            result = em.executeQuery(query);
            obj.verifyEqual(result, {'17-May-2016'; '18-May-2016'; '19-May-2016'});
            
            actual.dateString = result{1};
            em.find(actual);
            
            obj.verifyEqual(actual.integer, expected.integer);
            obj.verifyEqual(actual.double, expected.double);
            obj.verifyEqual(actual.string, expected.string);
        end
    end
end

