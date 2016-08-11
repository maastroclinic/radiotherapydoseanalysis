classdef testCalculateDvhV < matlab.unittest.TestCase
    
    properties
        V_DOSE = [0; 1; 2; 3; 4];
        V_VOLUME = [3.375; 3.375; 1; 0.1250; 0];
        DVH_V1   = 3.375;
        DVH_V1_5 = 1;
        DVH_V2   = 1;
        DVH_V2_5 = 0.1250;
        DVH_V3   = 0.1250;
        
        PIXELSPACING = [0.5, 0.5, 0.5];
        VOLUME = 3.375;
        RELATIVE_TOLLERANCE = 0.001;
    end
    
    methods(Test)
        function testVparamAbsolute(this)
            [ v ] = calculateDvhV(this.V_VOLUME, this.V_DOSE, 1, false, []);
            verifyEqual(this, v, this.DVH_V1, 'RelTol', this.RELATIVE_TOLLERANCE);
            
            [ v ] = calculateDvhV(this.V_VOLUME, this.V_DOSE, 1.5, false, []);
            verifyEqual(this, v, this.DVH_V1_5, 'RelTol', this.RELATIVE_TOLLERANCE);
            
            [ v ] = calculateDvhV(this.V_VOLUME, this.V_DOSE, 2, false, []);
            verifyEqual(this, v, this.DVH_V2, 'RelTol', this.RELATIVE_TOLLERANCE);
            
            [ v ] = calculateDvhV(this.V_VOLUME, this.V_DOSE, 2.5, false, []);
            verifyEqual(this, v, this.DVH_V2_5, 'RelTol', this.RELATIVE_TOLLERANCE);
            
            [ v ] = calculateDvhV(this.V_VOLUME, this.V_DOSE, 3, false, []);
            verifyEqual(this, v, this.DVH_V3, 'RelTol', this.RELATIVE_TOLLERANCE);
        end
        
        function testVparamRelative(this)
            [ v ] = calculateDvhV(this.V_VOLUME, this.V_DOSE, 1, true, this.VOLUME);
            verifyEqual(this, v, this.DVH_V1/(this.VOLUME/100), 'RelTol', this.RELATIVE_TOLLERANCE);
            
            [ v ] = calculateDvhV(this.V_VOLUME, this.V_DOSE, 1.5, true, this.VOLUME);
            verifyEqual(this, v, this.DVH_V1_5/(this.VOLUME/100), 'RelTol', this.RELATIVE_TOLLERANCE);
            
            [ v ] = calculateDvhV(this.V_VOLUME, this.V_DOSE, 2, true, this.VOLUME);
            verifyEqual(this, v, this.DVH_V2/(this.VOLUME/100), 'RelTol', this.RELATIVE_TOLLERANCE);
            
            [ v ] = calculateDvhV(this.V_VOLUME, this.V_DOSE, 2.5, true, this.VOLUME);
            verifyEqual(this, v, this.DVH_V2_5/(this.VOLUME/100), 'RelTol', this.RELATIVE_TOLLERANCE);
            
            [ v ] = calculateDvhV(this.V_VOLUME, this.V_DOSE, 3, true, this.VOLUME);
            verifyEqual(this, v, this.DVH_V3/(this.VOLUME/100), 'RelTol', this.RELATIVE_TOLLERANCE);
        end
    end
    
end