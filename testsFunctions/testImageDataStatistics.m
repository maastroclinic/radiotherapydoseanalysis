classdef testImageDataStatistics < matlab.unittest.TestCase
  properties
        image1;
        image2;
        image3;
        
        %replace one value in a matrix with 3, this should be the result of nanmin
        REF_VALUE1 = 3;
        %replace one value in a matrix with 7, this should be the result of nanmax
        REF_VALUE2 = 7;
        %create a matrix 10x10x10 matrix, where the first and last slice are NaN,
        % slice 2 to 9 are filled with 1 to 8. 10x10x1 + 10x10x2 etc results in an average of 4.5
        REF_VALUE3 = 4.5;
        
        RELATIVE_TOLLERANCE = 0.001;
    end
    
    methods (TestClassSetup)
        function setupOnce(this)
            baseImage = ones(10,10,10);
            baseImage(:,1,:) = NaN;
            baseImage(:,10,:) = NaN;
            
            this.image1 = baseImage .* 5;
            this.image1(5,5,5) = 3;
            
            this.image2 = baseImage .* 5;
            this.image2(4,5,7) = 7;
            
            this.image3 = baseImage;
            for i = 2:9
                this.image3(:,i,:) = i-1;
            end
        end
    end
    
    methods(Test)
        function testValues(this)
            value1 = imageDataStatistics(this.image1, 'min');
            value2 = imageDataStatistics(this.image2, 'max');
            value3 = imageDataStatistics(this.image3, 'mean');
            
            verifyEqual(this, value1, this.REF_VALUE1, 'RelTol', this.RELATIVE_TOLLERANCE);
            verifyEqual(this, value2, this.REF_VALUE2, 'RelTol', this.RELATIVE_TOLLERANCE);
            verifyEqual(this, value3, this.REF_VALUE3, 'RelTol', this.RELATIVE_TOLLERANCE);
        end
        
        function testInvalidInputs(this)
            try
                imageDataStatistics('derp', 'min');
            catch EM
                verifyEqual(this, 'imageDataStatistics:InputTypeMismatch', EM.identifier);
            end
            
            try
                imageDataStatistics(this.image1, 1);
            catch EM
                verifyEqual(this, 'imageDataStatistics:InputTypeMismatch', EM.identifier);
            end
            
            try
                imageDataStatistics(this.image1, 'derp');
            catch EM
                verifyEqual(this, 'imageDataStatistics:InvalidInput', EM.identifier);
            end
        end
    end
end