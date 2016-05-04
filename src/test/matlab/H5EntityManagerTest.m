classdef H5EntityManagerTest < matlab.unittest.TestCase
   
    properties(Constant)
        ID = 'A'
        
    end

    properties
        entityManager
    end
    
    methods
        function obj = H5EntityManagerTest()
            cp = getClassPath();
            h5Properties = [cp.test_resources 'test-h5properties.json'];
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
        
        function testInsertCompoundDataSet(obj)
            em = obj.entityManager;
            
            expected = entity.CompoundEntityDS('compound_ds');
            expected.integers = int32([10; 20; 30; 40]);
            expected.doubles = [5.1; 10.1; 20.1; 40.1];
            expected.strings = {'abc'; 'def'; 'ghi'; 'jkl' };
            em.insertCompoundDataSet(expected);
            
            actual = entity.CompoundEntityDS('compound_ds');
            em.findCompoundDataSet(actual);
            
            obj.verifyEqual(actual.integers, expected.integers);
            obj.verifyEqual(actual.doubles, expected.doubles);
            obj.verifyEqual(actual.strings, expected.strings);
        end

        function testInsertCompoundAttribute(obj)
            em = obj.entityManager;
            
            expected = entity.CompoundEntityAttr('compound_attr');
            expected.integers = int32([10; 20; 30; 40]);
            expected.doubles = [5.1; 10.1; 20.1; 40.1];
            expected.strings = {'abc'; 'def'; 'ghi'; 'jkl' };
            em.insertCompoundAttributes(expected);
            
            actual = entity.CompoundEntityAttr('compound_attr');
            em.findCompoundAttributes(actual);
            
            obj.verifyEqual(actual.integers, expected.integers);
            obj.verifyEqual(actual.doubles, expected.doubles);
            obj.verifyEqual(actual.strings, expected.strings);
        end

        function testInsertSimpleAttribute(obj)
            em = obj.entityManager;
            
            expected = entity.SimpleEntityAttr('simple_attr');
            expected.integer = int32(10);
            expected.double = 5.1;
            expected.string = 'abc';
            em.insertSimpleAttributes(expected);
            
            actual = entity.SimpleEntityAttr('simple_attr');
            em.findSimpleAttributes(actual);
            
            obj.verifyEqual(actual.integer, expected.integer);
            obj.verifyEqual(actual.double, expected.double);
            obj.verifyEqual(actual.string, expected.string);
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
        end
    end
end

