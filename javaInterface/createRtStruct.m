%CREATERTSTRUCT provides Java with the necessary RTSTRUCT object.
%   Software Development Team MAASTRO clinic.
function [rtStruct] = createRtStruct(pathStruct)    
    if ~exist(pathStruct, 'file')
        EM = MException('matlabData:MissingParamater', 'A RT-STRUCT file was not correctly specified');
        throw(EM);
    end
    rtStruct = RtStruct(pathStruct, true);
end