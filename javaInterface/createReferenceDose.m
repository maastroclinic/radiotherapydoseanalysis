%CREATEREFERENCEDOSE provides Java with the necessary dosereference to perform
%calculations with CALCULATESTRUCTEDATAWRAPPER. To shorten computation
%times this load was split from the calculations

%   See also ROIDOSE, RTDOSE, CT, CALCULATIONGRID.
%   Software Development Team MAASTRO CLinic.
function referenceDose = createReferenceDose(pathDose, referenceImage)    
    dose = RtDose(pathDose, false);
    doseImage = createImageFromRtDose(dose);
    referenceDose = matchImageRepresentation(doseImage, referenceImage);
end