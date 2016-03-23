classdef testCalculateBitmaskVolume < matlab.unittest.TestCase
 
    properties
        bitmask1;
        bitmask2;

        SPACING1 = [1,1,1];
        SPACING2 = [2,2,2];
        
        REF_VALUE1 = 300;
        REF_VALUE2 = 2400;
        REF_VALUE3 = 600;
        REF_VALUE4 = 4800;
        
        RELATIVE_TOLLERANCE = 0.001;
    end
    
    methods (TestClassSetup)
        function setupOnce(this)
            this.bitmask1 = false(10,6,10);
            this.bitmask1(:,1:3,:) = true;
            this.bitmask2 = true(10,6,10);
        end
    end
    
    methods(Test)
        function testCalculateVolumes(this)
            value1 = calculateBitmaskVolume(this.bitmask1, this.SPACING1);
            value2 = calculateBitmaskVolume(this.bitmask1, this.SPACING2);
            value3 = calculateBitmaskVolume(this.bitmask2, this.SPACING1);
            value4 = calculateBitmaskVolume(this.bitmask2, this.SPACING2);
            
            verifyEqual(this, value1, this.REF_VALUE1, 'RelTol', this.RELATIVE_TOLLERANCE);
            verifyEqual(this, value2, this.REF_VALUE2, 'RelTol', this.RELATIVE_TOLLERANCE);
            verifyEqual(this, value3, this.REF_VALUE3, 'RelTol', this.RELATIVE_TOLLERANCE);
            verifyEqual(this, value4, this.REF_VALUE4, 'RelTol', this.RELATIVE_TOLLERANCE);
        end
        
        function testInvalidInputs(this)
            try
                calculateBitmaskVolume('derp', []);
            catch EM
                verifyEqual(this, 'calculateBitmaskVolume:InputTypeMismatch', EM.identifier);
            end

            try
                calculateBitmaskVolume(this.bitmask1, 'derp');
            catch EM
                verifyEqual(this, 'calculateBitmaskVolume:InputTypeMismatch', EM.identifier);
            end
            
            try
                calculateBitmaskVolume(this.bitmask1, [1,1]);
            catch EM
                verifyEqual(this, 'calculateBitmaskVolume:InputDimensionMismatch', EM.identifier);
            end
        end
    end
end