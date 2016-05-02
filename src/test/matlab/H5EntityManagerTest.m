classdef H5EntityManagerTest < matlab.unittest.TestCase
    properties
        id = 'A'
    end
    
    methods(Test)
        
        function testCreateEntityManager(obj)
            em = io.mpa.persistence.createEntityManager(obj.id);
            obj.verifyNotEmpty(em.fname);
            obj.verifyEqual(em.entityMap.keys, sort({'COMPUND_ENTITY_ATTR', 'COMPUND_ENTITY_DS'}));
        end
        
        function testInsertCompoundDataSet(obj)
            em = io.mpa.persistence.createEntityManager(obj.id);
            
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
    end
end

