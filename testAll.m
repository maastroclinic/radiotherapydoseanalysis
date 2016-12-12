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
testCalc = testAllCalculationWrappers();
resultCalculations = testCalc.run()
