classdef testCalculateDvhCurve  < matlab.unittest.TestCase
    
    properties
        cube
        dvh_ref_abs
        dvh_ref_rel;
        
        BINSIZE = 1;
        PIXELSPACING = [0.5, 0.5, 0.5];
        VOLUME = 3.375;
        RELATIVE_TOLLERANCE = 0.001;
    end
    
    methods (TestClassSetup)
        function setupOnce(this)
            this.cube = ones(3,3,3);
            this.cube(1:2, 1:2, 1:2) = 2;
            this.cube(1,1,1) = 3;
            
            dvh = [3*3*3; 3*3*3; 2*2*2; 1*1*1; 0]; 
            %the DVH is the count of voxels with a dose higher than the threshold
            %the theoretical count [27, 8, 1] but the greater than 0 and 4 is added at the ends 
            this.dvh_ref_abs = dvh .* prod(this.PIXELSPACING);
            this.dvh_ref_rel = (dvh .* prod(this.PIXELSPACING))./(this.VOLUME/100);
        end
    end
    
    methods(Test)
        function testSimpleCurve(this)
            [ vVolume, ~ ] = calculateDvhCurve(this.cube, this.BINSIZE, this.PIXELSPACING, false, []);
            verifyEqual(this, vVolume, this.dvh_ref_abs, 'RelTol', this.RELATIVE_TOLLERANCE);
            [ vVolume, ~ ] = calculateDvhCurve(this.cube, this.BINSIZE, this.PIXELSPACING, true, this.VOLUME);
            verifyEqual(this, vVolume, this.dvh_ref_rel, 'RelTol', this.RELATIVE_TOLLERANCE);
        end
    end
    
end

