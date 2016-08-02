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
        vois = [];
        referenceDose = [];
        gtv1Dvh = [];
        gtv1plus2Dvh = [];
        gtv2min1Dvh = [];
        
        %wrapper operation instructions
        V_LIMIT = 48;
        D_LIMIT = 2;
        D_LIMIT_ABS = 0;
        TARGET_PRESCRIPTION_DOSE    = 45;
        RTVOLUME_EXPORT  = 'export';
        DVH_BINSIZE      = 1 %Gy
        
        doseOperations = [];
        requiredOutput = [];
        
        % Results
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

        % Required for setup
        wrapperData;
        wrapperDataNoDose;
    end
    
    methods (TestClassSetup)
        function setupOnce(me)       
            me.ctJava = mockJavaCtProperties(fullfile(me.BasePath, 'CT'));
            me.pathCt =     fullfile(me.BasePath, 'CT');
            me.pathDose   = fullfile(me.BasePath, 'RTDOSE' , me.RTDoseFile);
            me.pathStruct = fullfile(me.BasePath, 'RTSTRUCT' , me.RTStructFile);
            me.referenceImage = createImageFromCtProperties(me.ctJava);
            
            me.vois = createVoiMap(me.pathStruct, ...
                            me.referenceImage, ...
                            {'GTV-1','GTV-2'});
            me.referenceDose = createReferenceDose(me.pathDose, ...
                                                 me.referenceImage);
                                             
            gtv1Dose = createImageDataForVoi(me.vois(1).voi, ...
                                              me.referenceDose);
            me.gtv1Dvh = DoseVolumeHistogram(gtv1Dose, 0.00001);
            gtv1plus2Dose = createImageDataForVoi(addVois(me.vois(1).voi,me.vois(2).voi), ...
                                  me.referenceDose);
            calculateDvhCurve(gtv1plus2Dose, 0.00001, false);
            me.gtv1plus2Dvh = DoseVolumeHistogram(gtv1plus2Dose, 0.00001);
            gtv2min1Dose = createImageDataForVoi(subtractVois(me.vois(2).voi,me.vois(1).voi), ...
                                  me.referenceDose);
            me.gtv2min1Dvh = DoseVolumeHistogram(gtv2min1Dose, 0.00001);
        end
    end    
    
    methods(Test)
        
		function testCalculateVolume(me)
            verifyEqual(me, me.gtv1Dvh.volume, me.volumeGTV1, 'RelTol', me.relativeError);
            verifyEqual(me, me.gtv1plus2Dvh.volume, me.volumeSum, 'RelTol', me.relativeError);
            verifyEqual(me, me.gtv2min1Dvh.volume, me.volumeDifference, 'RelTol', me.relativeError);
        end
        
        function testCalculateDose(me)
            verifyEqual(me, me.gtv1Dvh.minDose, me.doseMinGTV1, 'RelTol', me.relativeError);
            verifyEqual(me, me.gtv1plus2Dvh.minDose, me.doseMinSum, 'RelTol', me.relativeError);
            verifyEqual(me, me.gtv2min1Dvh.minDose, me.doseMinDifference, 'RelTol', me.relativeError);
            
            verifyEqual(me, me.gtv1Dvh.meanDose, me.doseMeanGTV1, 'RelTol', me.relativeError);
            verifyEqual(me, me.gtv1plus2Dvh.meanDose, me.doseMeanSum, 'RelTol', me.relativeError);
            verifyEqual(me, me.gtv2min1Dvh.meanDose, me.doseMeanDifference, 'RelTol', me.relativeError);
            
            verifyEqual(me, me.gtv1Dvh.maxDose, me.doseMaxGTV1, 'RelTol', me.relativeError);
            verifyEqual(me, me.gtv1plus2Dvh.maxDose, me.doseMaxSum, 'RelTol', me.relativeError);
            verifyEqual(me, me.gtv2min1Dvh.maxDose, me.doseMaxDifference, 'RelTol', me.relativeError);
        end
        
        function testCalculateDvhV(me)
            verifyEqual(me, calculateDvhV(me.gtv1Dvh, me.V_LIMIT, true), me.volume48GyGTV1, 'RelTol', me.relativeError);
            verifyEqual(me, calculateDvhV(me.gtv1plus2Dvh, me.V_LIMIT, true), me.volume48GySum, 'RelTol', me.relativeError);
            verifyEqual(me, calculateDvhV(me.gtv2min1Dvh, me.V_LIMIT, true), me.volume48GyDifference, 'RelTol', me.relativeError);
        end
        
        function testCalculateDvhD(me)  
            verifyEqual(me, calculateDvhD(me.gtv1Dvh, me.D_LIMIT, '%', []), me.dose2PercentGTV1, 'RelTol', me.relativeError);
            verifyEqual(me, calculateDvhD(me.gtv1plus2Dvh, me.D_LIMIT, '%', []), me.dose2PercentSum, 'RelTol', me.relativeError);
            verifyEqual(me, calculateDvhD(me.gtv2min1Dvh, me.D_LIMIT, '%', []), me.dose2PercentDifference, 'RelTol', me.relativeError);
        end
    end
end