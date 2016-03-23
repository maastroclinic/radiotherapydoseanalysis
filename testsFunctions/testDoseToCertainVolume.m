classdef testDoseToCertainVolume < matlab.unittest.TestCase
    
    properties
        image1;
        
        
        %3 slices of 10x10 with pixel spacing 1,1,1 results in a volume of 30
        REF_VOLUME1 = 30;
        %3 slices of 10x10 with pixel spacing 2,2,2 results in a volume of 8x30
        REF_VOLUME2 = 240;
        %6 slices of 10x10 with pixel spacing 1,1,1 results in a volume of 30
        REF_VOLUME3 = 60;
        %6 slices of 10x10 with pixel spacing 2,2,2 results in a volume of 8x30
        REF_VOLUME4 = 480;
        
        RELATIVE_TOLLERANCE = 0.001;
    end
    
    methods (TestClassSetup)
        function setupOnce(this)
            baseImage = ones(10,10,10);
            baseImage(:,1,:) = NaN;
            baseImage(:,10,:) = NaN;
            
            this.image1 = baseImage;
            for i = 2:9
                this.image1(:,i,:) = i-1;
            end
        end
    end
    
    methods(Test)
        function testDvhD(this)
            volume1 = calculateBitmaskVolume(this.bitmask1, this.SPACING1);

            
%             verifyEqual(this, volume1, this.REF_VOLUME1, 'RelTol', this.RELATIVE_TOLLERANCE);

        end
        
        function testInvalidInputs(this)
%             try
%                 calculateBitmaskVolume(double(this.bitmask1), '');
%             catch EM
%                 verifyEqual(this, 'calculateBitmaskVolume:InputTypeMismatch', EM.identifier);
%             end
%             
%             try
%                 calculateBitmaskVolume(this.bitmask1, '');
%             catch EM
%                 verifyEqual(this, 'calculateBitmaskVolume:InputTypeMismatch', EM.identifier);
%             end
%             
%             try
%                 calculateBitmaskVolume(this.bitmask1, [1,1]);
%             catch EM
%                 verifyEqual(this, 'calculateBitmaskVolume:InputDimensionMismatch', EM.identifier);
%             end
%             
        end
    end
end