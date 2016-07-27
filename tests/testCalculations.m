classdef testCalculations < matlab.unittest.TestCase

    properties

        % Locations of test files
        BasePath = '\\dev-build.maastro.nl\testdata\DIU\dicomutilitiesmatlab';
        RTStructFile = '\FO-4073997332899944647.dcm';
        RTDoseFile   = '\FO-3153671375338877408_v2.dcm';
        
        % Results 
        volumeNaN = NaN;
        volumeGtv1 = 57.7583;
        volume48GyGtv1 = 70.5122;
        dose2PercentGtv1 = 49.9198;  
        doseMinGtv1 = 45.4715;
        doseMaxGtv1 = 50.7382;
        doseMeanGtv1 = 48.3759;
        volumeGtv2 = 178.9627;
        volume48GyGtv2 = 7.9438;
        dose2PercentGtv2 = 48.5947; 
        doseMinGtv2 = 42.3714;
        doseMaxGtv2 = 49.7521;
        doseMeanGtv2 = 46.5160;
        volumeSum = 236.6924;
        volume48GySum = 23.2092;
        dose2PercentSum = 49.40467; 
        doseMinSum = 42.3714;
        doseMaxSum = 50.7382;
        doseMeanSum = 46.9698;
        volumeDifference = 178.9341;
        volume48GyDifference = 7.9403;
        dose2PercentDifference = 48.5946; 
        doseMinDifference = 42.3714;
        doseMaxDifference = 49.7521;
        doseMeanDifference = 46.5159;
        bodyVolume = 2.0912e+04;
        %there are some unused values in here, leave them for reference
        %purposes
        
        relativeError = 0.0035;

        % Required for setup
        oldPath;
        rtStruct;
        mismatchRtStruct;
        calcGrid;
        mismatchCalcGrid;
        rtDose;
        mismatchRtDose;
        Gtv1; Gtv2; 
        mismatchGtv1;
        
        BINSIZE = 0.001;
    end
    
    methods (TestClassSetup)
        function setupOnce(this)
            ct = Ct(fullfile(this.BasePath, 'CT'), 'folder', false);
            this.calcGrid = CalculationGrid(ct, 'ct');               
            this.rtDose   = RtDose(fullfile(this.BasePath, 'RTDOSE' , this.RTDoseFile), this.calcGrid.PixelSpacing, this.calcGrid.Origin, this.calcGrid.Axis, this.calcGrid.Dimensions);
            this.rtStruct = RtStruct(fullfile(this.BasePath, 'RTSTRUCT' , this.RTStructFile), this.calcGrid.PixelSpacing, this.calcGrid.Origin, this.calcGrid.Axis, this.calcGrid.Dimensions);
            this.Gtv1 = Image('GTV-1', this.rtStruct.getRoiMask('GTV-1'), this.rtDose.fittedDoseCube, this.calcGrid.PixelSpacing, this.calcGrid.Origin, this.calcGrid.Axis, this.calcGrid.Dimensions);
            this.Gtv2 = Image('GTV-2', this.rtStruct.getRoiMask('GTV-2'), this.rtDose.fittedDoseCube, this.calcGrid.PixelSpacing, this.calcGrid.Origin, this.calcGrid.Axis, this.calcGrid.Dimensions);
            
%             ct = Ct(fullfile(me.BasePath, 'CT_DIMTEST'), 'folder', false);
%             me.mismatchCalcGrid = CalculationGrid(ct, 'ct'); 
%             me.mismatchRtStruct = RtStruct(fullfile(me.BasePath, 'RTSTRUCT' , me.RTStructFile), me.mismatchCalcGrid);
%             me.mismatchRtDose   = RtDose(fullfile(me.BasePath, 'RTDOSE' , me.RTDoseFile), me.mismatchCalcGrid);
%             me.mismatchGtv1 = RtVolume('GTV-1', me.mismatchCalcGrid, me.mismatchRtStruct, me.mismatchRtDose);
        end
    end    
 
    methods(Test)
        function testParseDoseSeperately(this)
            Gtv = Image('GTV-1', this.rtStruct.getRoiMask('GTV-1'), [], this.calcGrid.PixelSpacing, this.calcGrid.Origin, this.calcGrid.Axis, this.calcGrid.Dimensions);
            Gtv = Gtv.addImageData(this.rtDose.fittedDoseCube);
            
            dMin = calculateDose(Gtv.maskedData, 'min');
            verifyEqual(this, dMin, this.doseMinGtv1, 'RelTol', this.relativeError);
            
            [ vVolume, vDose ] = calculateDvhCurve(Gtv.maskedData, this.BINSIZE, Gtv.PixelSpacing, false, Gtv.volume);

            v48 = calculateDvhV(vVolume, vDose, 48, true, Gtv.volume);
            verifyEqual(this, v48, this.volume48GyGtv1, 'RelTol', this.relativeError);            
            
            d2 = calculateDvhD(vVolume, vDose, 2, true, Gtv.volume, false, []);
            verifyEqual(this, d2, this.dose2PercentGtv1, 'RelTol', this.relativeError);
        end
        
        function testCtVolumeGtv1(this)
            ct = Ct(fullfile(this.BasePath, 'CT'), 'folder', true);
            GtvCt =Image('GTV-1', this.rtStruct.getRoiMask('GTV-1'), ct.imageData, this.calcGrid.PixelSpacing, this.calcGrid.Origin, this.calcGrid.Axis, this.calcGrid.Dimensions);
            verifyEqual(this, double(~isnan(GtvCt.maskedData)), GtvCt.bitmask);
        end
        
        function testGtv1(this)
            verifyEqual(this, this.Gtv1.name, 'GTV-1'); 
            verifyEqual(this, this.Gtv1.volume, this.volumeGtv1, 'RelTol', this.relativeError); 
            
            dMin = calculateDose(this.Gtv1.maskedData, 'min');
            verifyEqual(this, dMin, this.doseMinGtv1, 'RelTol', this.relativeError);    
            
            dMean = calculateDose(this.Gtv1.maskedData, 'mean');
            verifyEqual(this, dMean, this.doseMeanGtv1, 'RelTol', this.relativeError);
            verifyGreaterThanOrEqual(this, dMean, dMin); 
            
            dMax = calculateDose(this.Gtv1.maskedData, 'max');
            verifyEqual(this, dMax, this.doseMaxGtv1, 'RelTol', this.relativeError);             
            verifyGreaterThanOrEqual(this, dMax, dMean);
            
            [ vVolume, vDose ] = calculateDvhCurve(this.Gtv1.maskedData, this.BINSIZE, this.Gtv1.PixelSpacing, false, this.Gtv1.volume);
            
            v48 = calculateDvhV(vVolume, vDose, 48, true, this.Gtv1.volume);
            verifyEqual(this, v48, this.volume48GyGtv1, 'RelTol', this.relativeError);            
            
            d2 = calculateDvhD(vVolume, vDose, 2, true, this.Gtv1.volume, false, []);
            verifyEqual(this, d2, this.dose2PercentGtv1, 'RelTol', this.relativeError);
            
            
        end

        function testGtv2(this)
            verifyEqual(this, this.Gtv2.name, 'GTV-2'); 
            verifyEqual(this, this.Gtv2.volume, this.volumeGtv2, 'RelTol', this.relativeError);
            
            dMin = calculateDose(this.Gtv2.maskedData, 'min');
            verifyEqual(this, dMin, this.doseMinGtv2, 'RelTol', this.relativeError);
            
            [ vVolume, vDose ] = calculateDvhCurve(this.Gtv2.maskedData, this.BINSIZE, this.Gtv2.PixelSpacing, false, this.Gtv2.volume);
            
            v48 = calculateDvhV(vVolume, vDose, 48, true, this.Gtv2.volume);
            verifyEqual(this, v48, this.volume48GyGtv2, 'RelTol', this.relativeError); 
            
            d2 = calculateDvhD(vVolume, vDose, 2, true, this.Gtv2.volume, false, []);
            verifyEqual(this, d2, this.dose2PercentGtv2, 'RelTol', this.relativeError); 
        end

        function testOperatorsSum(this)
            sum = this.Gtv1 + this.Gtv2;            
            verifyEqual(this, sum.name, 'GTV-1+GTV-2'); 
            
            dMean = calculateDose(sum.maskedData, 'mean');
            verifyEqual(this, dMean, this.doseMeanSum, 'RelTol', this.relativeError);
            
            [ vVolume, vDose ] = calculateDvhCurve(sum.maskedData, this.BINSIZE, sum.PixelSpacing, false, sum.volume);
            
            v48 = calculateDvhV(vVolume, vDose, 48, true, sum.volume);
            verifyEqual(this, v48, this.volume48GySum, 'RelTol', this.relativeError);            
            
            d2 = calculateDvhD(vVolume, vDose, 2, true, sum.volume, false, []);
            verifyEqual(this, d2, this.dose2PercentSum, 'RelTol', this.relativeError); 
        end

        function testOperatorsDifference(this)
            sum = this.Gtv1 + this.Gtv2;
            difference = sum - this.Gtv1;
            verifyEqual(this, difference.name, 'GTV-1+GTV-2-GTV-1'); 
            verifyEqual(this, difference.volume, this.volumeDifference, 'RelTol', this.relativeError);           
            
%             doseMax = difference.dose('max');
%             verifyEqual(me, doseMax, me.doseMaxDifference, 'RelTol', me.relativeError); 
%             verifyEqual(me, me.volume48GyDifference, difference.volumePercentageWithDoseOf(48), 'RelTol', me.relativeError);             
%             verifyEqual(me, me.dose2PercentDifference, difference.doseToCertainVolumePercentage(2), 'RelTol', me.relativeError);
        end
        
        function testCompressionCloseToCtBoundries(this)
            body = Image('Body', this.rtStruct.getRoiMask('Body'), this.rtDose.fittedDoseCube, this.calcGrid.PixelSpacing, this.calcGrid.Origin, this.calcGrid.Axis, this.calcGrid.Dimensions);
            verifyEqual(this, body.volume, this.bodyVolume, 'RelTol', this.relativeError);
        end
        
%         function testDoseOverwrite(me)
%             try
%                 me.Gtv1.addRtDose(me.rtDose);
%             catch EM
%                 verifyEqual(me, 'RtVolume:rtDoseOverwrite', EM.identifier);
%             end
%             
%         end
%         
%         function testDoseMismatch(me)
%             try
%                 Gtv = RoiDose('GTV-1', me.calcGrid, me.rtStruct);
%                 Gtv.addRtDose(me.mismatchRtDose);
%             catch EM
%                 verifyEqual(me, 'RtVolume:DimensionMismatch', EM.identifier);
%             end
%         end
%         
%         function testPlusMismatch(me)
%             try
%                 sum = me.Gtv1 + me.mismatchGtv1; %#ok<NASGU>
%             catch EM
%                 verifyEqual(me, 'AbstractVolume:PlusDimensionMismatch', EM.identifier);
%             end
%         end
%         
%         function testMinusMismatch(me)
%             try
%                 diff = me.Gtv1 - me.mismatchGtv1; %#ok<NASGU>
%             catch EM
%                 verifyEqual(me, 'AbstractVolume:MinusDimensionMismatch', EM.identifier);
%             end
%         end
    end
end