classdef HelloWorldTest < matlab.unittest.TestCase
    
    properties
    end
    
    methods(Test)
        
        function testResourceProperties(obj)
            p = HelloWorld().resourceProperties;
            for i = 1 : numel(p)
                obj.verifyEqual(p{i}.key, strcat('value', num2str(i)));
            end
        end
    end
    
end

