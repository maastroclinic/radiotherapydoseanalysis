classdef testCalculateDvhD < matlab.unittest.TestCase
    
     properties
        V_DOSE = [0; 1; 2; 3; 4];
        V_VOLUME = [3.375; 3.375; 1; 0.1250; 0];
        DVH_D0_1250 = 3;
        DVH_D1      = 2;
        DVH_D3_375  = 0;
        
        DVH_LIMIT1 = 0.1250;
        DVH_LIMIT2 = 1;
        DVH_LIMIT3 = 3.375;
        
        PIXELSPACING = [0.5, 0.5, 0.5];
        VOLUME = 3.375;
        RELATIVE_TOLLERANCE = 0.001;
        
        TARGET_PRESCRIPTION_DOSE = 2;
    end
    
    methods(Test)
        function testDparamAbsolute(this)
            [ d ] = calculateDvhD(this.V_VOLUME, this.V_DOSE, this.DVH_LIMIT1, false, [], false, []);
            verifyEqual(this, d, this.DVH_D0_1250, 'RelTol', this.RELATIVE_TOLLERANCE);
            
            [ d ] = calculateDvhD(this.V_VOLUME, this.V_DOSE, this.DVH_LIMIT2, false, [], false, []);
            verifyEqual(this, d, this.DVH_D1, 'RelTol', this.RELATIVE_TOLLERANCE);
            
            [ d ] = calculateDvhD(this.V_VOLUME, this.V_DOSE, this.DVH_LIMIT3, false, [], false, []);
            verifyEqual(this, d, this.DVH_D3_375, 'RelTol', this.RELATIVE_TOLLERANCE);
        end
        
        function testDparamRelativeInput(this)
            [ d ] = calculateDvhD(this.V_VOLUME, this.V_DOSE, this.DVH_LIMIT1/(this.VOLUME/100), true, this.VOLUME, false, []);
            verifyEqual(this, d, this.DVH_D0_1250, 'RelTol', this.RELATIVE_TOLLERANCE);
            
            [ d ] = calculateDvhD(this.V_VOLUME, this.V_DOSE, this.DVH_LIMIT2/(this.VOLUME/100), true, this.VOLUME, false, []);
            verifyEqual(this, d, this.DVH_D1, 'RelTol', this.RELATIVE_TOLLERANCE);
            
            [ d ] = calculateDvhD(this.V_VOLUME, this.V_DOSE, this.DVH_LIMIT3/(this.VOLUME/100), true, this.VOLUME, false, []);
            verifyEqual(this, d, this.DVH_D3_375, 'RelTol', this.RELATIVE_TOLLERANCE);
        end
        
        function testDparamRelativeOutput(this)
            [ d ] = calculateDvhD(this.V_VOLUME, this.V_DOSE, this.DVH_LIMIT1, false, [], true, this.TARGET_PRESCRIPTION_DOSE);
            verifyEqual(this, d, this.DVH_D0_1250/(this.TARGET_PRESCRIPTION_DOSE/100), 'RelTol', this.RELATIVE_TOLLERANCE);
            
            [ d ] = calculateDvhD(this.V_VOLUME, this.V_DOSE, this.DVH_LIMIT2, false, [], true, this.TARGET_PRESCRIPTION_DOSE);
            verifyEqual(this, d, this.DVH_D1/(this.TARGET_PRESCRIPTION_DOSE/100), 'RelTol', this.RELATIVE_TOLLERANCE);
            
            [ d ] = calculateDvhD(this.V_VOLUME, this.V_DOSE, this.DVH_LIMIT3, false, [], true, this.TARGET_PRESCRIPTION_DOSE);
            verifyEqual(this, d, this.DVH_D3_375/(this.TARGET_PRESCRIPTION_DOSE/100), 'RelTol', this.RELATIVE_TOLLERANCE);
        end
    end
    
end