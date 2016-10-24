addpath(genpath('dependencies'));
addpath(genpath('javaInterface'));
addpath(genpath('testsFunctions'));
addpath(genpath('tests'));
%ADD PATH TO DICOM UTILITIES MATLAB HERE!
% https://dev-git.maastro.nl/projects/DIU/repos/dicomutilitiesmatlab
addpath(genpath('dicomutilitiesmatlab'));
addpath('dicom-file-interface\classes'); 
addpath('dicom-file-interface\dependencies'); 
addpath('dicom-file-interface\functions');


%%
testVolume = testCalculateVolume();
resultVolume = testVolume.run();

testDose = testCalculateDose();
resultDose = testDose.run();

testDvhD = testCalculateDvhD();
resultDvhD = testDvhD.run();

testDvhV = testCalculateDvhV();
resultDvhV = testDvhV.run();

testDvhCurve = testCalculateDvhCurve();
resultDvhCurve = testDvhCurve.run();

testCalc = testCalculations();
resultCalculations = testCalc.run();

result = [resultVolume, ...
          resultDose, ...
          resultDvhD, ...
          resultDvhV, ...
          resultDvhCurve, ...
          resultCalculations]