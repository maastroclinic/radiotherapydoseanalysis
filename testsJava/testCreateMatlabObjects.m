classdef testCreateMatlabObjects < matlab.unittest.TestCase
    properties
        % Locations of test files
        % BasePath should be the path to the folder containing the CT, RTSTRUCT and RTDOSE folders
        BasePath = '\\dev-build.maastro.nl\testdata\DIU\dicomutilitiesmatlab';
        % Filenames should hold the filename of the RTSTRUCT file and RTDOSE file
        RTStructFile = 'FO-4073997332899944647.dcm';
        RTDoseFile   = 'FO-3153671375338877408_v2.dcm';

        NO_STRUCT  = 0;
        ONE_STRUCT = 1;
        TWO_STRUCT = 2;
        
        ctJava = [];
        pathCt = [];
        pathDose = [];
        pathStruct = [];
        referenceImage = [];
    end
    
    methods (TestClassSetup)
        function setupOnce(me)
            me.ctJava = mockJavaCtProperties(fullfile(me.BasePath, 'CT'));
            me.pathCt =     fullfile(me.BasePath, 'CT');
            me.pathDose   = fullfile(me.BasePath, 'RTDOSE' , me.RTDoseFile);
            me.pathStruct = fullfile(me.BasePath, 'RTSTRUCT' , me.RTStructFile);
            
            me.referenceImage = createImageFromCtProperties(me.ctJava);
        end
    end    
    
    methods(Test)
        function testJavaCtProperties(me)
            vois = createVoiMap(me.pathStruct, me.referenceImage, {'GTV-1'});
            verifyEqual(me, size(vois,2), me.ONE_STRUCT);
        end
        
        function testCtObject(me)
            vois = createVoiMap(me.pathStruct, me.referenceImage, {'GTV-1'});
            verifyEqual(me, size(vois,2), me.ONE_STRUCT);
        end
        
        function testCtPath(me)
            vois = createVoiMap(me.pathStruct, me.referenceImage, {'GTV-1'});
            verifyEqual(me, size(vois,2), me.ONE_STRUCT);
        end
                
		function testGetMultiple(me)
            vois = createVoiMap(me.pathStruct, me.referenceImage, {'GTV-1', 'GTV-2'});
            verifyEqual(me, size(vois,2), me.TWO_STRUCT);
        end
        
        function testRoiNotFoundSingle(me)
            vois = createVoiMap(me.pathStruct, me.referenceImage, {'DERP'});
            verifyEqual(me, size(vois,2), me.NO_STRUCT);
        end
        
        function testRoiNotFoundMultiple(me)
            vois = createVoiMap(me.pathStruct, me.referenceImage, {'DERP', 'GTV-1'});
            verifyEqual(me, size(vois,2), me.ONE_STRUCT);
        end
        
        function testErrorNoStruct(me)
            try
                createVoiMap('', me.referenceImage, {'GTV-1'});
            catch EM
                verifyEqual(me, 'matlabData:MissingParamater', EM.identifier);
            end
        end
        
        function testErrorNoVolumes(me)
            try
                createVoiMap(me.pathStruct, me.referenceImage, {[]});
            catch EM
                verifyEqual(me, 'matlabData:MissingParamater', EM.identifier);
            end
        end
        
        function testErrorInvalidCtProperties(me)
           errorCtProp = me.ctJava;
           errorCtProp = rmfield(errorCtProp, 'PixelSpacing');
           try
               createImageFromCtProperties(errorCtProp);
           catch EM
               verifyEqual(me, 'CtProperties:MissingParamater', EM.identifier);
           end
        end        
    end
end