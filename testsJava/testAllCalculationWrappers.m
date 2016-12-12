classdef testAllCalculationWrappers < matlab.unittest.TestCase
    properties
        
        % Locations of test files
        % BasePath should be the path to the folder containing the CT, RTSTRUCT and RTDOSE folders
        BasePath = '\\dev-build.maastro.nl\testdata\DIU\dicomutilitiesmatlab';
        % Filenames should hold the filename of the RTSTRUCT file and RTDOSE file
        RTStructFile = 'FO-4073997332899944647.dcm';
        RTDoseFile   = 'FO-3153671375338877408_v2.dcm';
        RTPlanFile   = 'FO-3630512758406762316.dcm';
        
        ctJava = [];
        pathCt = [];
        pathDose = [];
        pathStruct = [];
        referenceImage = [];
        rtStruct = [];

        %wrapper operation instructions
        V_LIMIT = 48;
        D_LIMIT = 2;
        D_LIMIT_ABS = 0;
        TARGET_PRESCRIPTION_DOSE    = 45;
        RTVOLUME_EXPORT  = 'export';
        DVH_BINSIZE      = 0.001 %Gy
        
        % Results
        maxDose = 50.7382;
        volumeGTV1 = 57.7583;
        volume48GyGTV1 = 70.5122;
        dose2PercentGTV1 = 49.9198; 
        doseMinGTV1 = 45.4715;
        doseMaxGTV1 = 50.7382;
        doseMeanGTV1 = 48.3759;
        volumeGTV2 = 178.9627;
        volume48GyGTV2 = 7.9438;
        dose2PercentGTV2 = 48.5947;
        doseMinGTV2 = 42.3714;
        doseMaxGTV2 = 49.7521;
        doseMeanGTV2 = 46.5160;
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

        relativeError = 0.0035;
    end
    
    methods (TestClassSetup)
        function setupOnce(this)       
            this.ctJava = mockJavaCtProperties(fullfile(this.BasePath, 'CT'));
            this.pathCt =     fullfile(this.BasePath, 'CT');
            this.pathDose   = fullfile(this.BasePath, 'RTDOSE' , this.RTDoseFile);
            this.pathStruct = fullfile(this.BasePath, 'RTSTRUCT' , this.RTStructFile);
            this.referenceImage = createImageFromCtProperties(this.ctJava);
            this.rtStruct = createRtStruct(this.pathStruct);
        end
    end    
    
    methods(Test)
        function testCreateReferenceDose(this)
            referenceDose = createReferenceDose(this.pathDose, this.referenceImage);
            verifyEqual(this, max(referenceDose.pixelData(:)), this.maxDose, 'RelTol', this.relativeError);
        end
        
        function testCreateDoseVolumeHistogram(this)                         
            referenceDose = createReferenceDose(this.pathDose, this.referenceImage);
            createDoseVolumeHistogram(this.rtStruct, ... 
                                             referenceDose, ...
                                             this.referenceImage, ...
                                             {'GTV-1'}, ...
                                             {}, ...
                                             0.01);
        end
        
        function testGtv1(this)
            referenceDose = createReferenceDose(this.pathDose, this.referenceImage);
            dvhDto = createDoseVolumeHistogram(this.rtStruct, ...
                referenceDose, ...
                this.referenceImage, ...
                {'GTV-1'}, ...
                {}, ...
                this.DVH_BINSIZE);
            gtv1Dvh = createDoseVolumeHistogramFromDto(dvhDto);
            verifyEqual(this, gtv1Dvh.volume, this.volumeGTV1, 'RelTol', this.relativeError);
            verifyEqual(this, gtv1Dvh.minDose, this.doseMinGTV1, 'RelTol', this.relativeError);
            verifyEqual(this, gtv1Dvh.meanDose, this.doseMeanGTV1, 'RelTol', this.relativeError);
            verifyEqual(this, gtv1Dvh.maxDose, this.doseMaxGTV1, 'RelTol', this.relativeError);
            verifyEqual(this, calculateDvhV(gtv1Dvh, this.V_LIMIT, true), this.volume48GyGTV1, 'RelTol', this.relativeError);
            verifyEqual(this, calculateDvhD(gtv1Dvh, this.D_LIMIT, '%', []), this.dose2PercentGTV1, 'RelTol', this.relativeError);
        end
        
        function testGtv1PlusGtv2(this)
            referenceDose = createReferenceDose(this.pathDose, this.referenceImage);
            dvhDto = createDoseVolumeHistogram(this.rtStruct, ...
                referenceDose, ...
                this.referenceImage, ...
                {'GTV-1', 'GTV-2'}, ...
                {'+'}, ...
                this.DVH_BINSIZE);
            gtv1plus2Dvh = createDoseVolumeHistogramFromDto(dvhDto);
            verifyEqual(this, gtv1plus2Dvh.volume, this.volumeSum, 'RelTol', this.relativeError);
            verifyEqual(this, gtv1plus2Dvh.minDose, this.doseMinSum, 'RelTol', this.relativeError);
            verifyEqual(this, gtv1plus2Dvh.meanDose, this.doseMeanSum, 'RelTol', this.relativeError);
            verifyEqual(this, gtv1plus2Dvh.maxDose, this.doseMaxSum, 'RelTol', this.relativeError);
            verifyEqual(this, calculateDvhV(gtv1plus2Dvh, this.V_LIMIT, true), this.volume48GySum, 'RelTol', this.relativeError);
            verifyEqual(this, calculateDvhD(gtv1plus2Dvh, this.D_LIMIT, '%', []), this.dose2PercentSum, 'RelTol', this.relativeError);
        end
        
        function testGtv1MinusGtv2(this)
            referenceDose = createReferenceDose(this.pathDose, this.referenceImage);
            dvhDto = createDoseVolumeHistogram(this.rtStruct, ...
                referenceDose, ...
                this.referenceImage, ...
                {'GTV-2', 'GTV-1'}, ...
                {'-'}, ...
                this.DVH_BINSIZE);
            gtv2min1Dvh = createDoseVolumeHistogramFromDto(dvhDto);
            verifyEqual(this, gtv2min1Dvh.volume, this.volumeDifference, 'RelTol', this.relativeError);
            verifyEqual(this, gtv2min1Dvh.minDose, this.doseMinDifference, 'RelTol', this.relativeError);
            verifyEqual(this, gtv2min1Dvh.meanDose, this.doseMeanDifference, 'RelTol', this.relativeError);
            verifyEqual(this, gtv2min1Dvh.maxDose, this.doseMaxDifference, 'RelTol', this.relativeError);
            verifyEqual(this, calculateDvhV(gtv2min1Dvh, this.V_LIMIT, true), this.volume48GyDifference, 'RelTol', this.relativeError);
            verifyEqual(this, calculateDvhD(gtv2min1Dvh, this.D_LIMIT, '%', []), this.dose2PercentDifference, 'RelTol', this.relativeError);
        end
    end
end