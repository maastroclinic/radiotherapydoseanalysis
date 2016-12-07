%CREATEREFERENCEDOSE provides Java with the necessary dosereference to perform
%calculations with CALCULATESTRUCTEDATAWRAPPER. To shorten computation
%times this load was split from the calculations

%   See also ROIDOSE, RTDOSE, CT, CALCULATIONGRID.
%   Software Development Team MAASTRO CLinic.
function dvhJson = createDoseVolumeHistogram(rtStruct, ... 
                                             referenceDose, ...
                                             referenceImage, ...
                                             roiNames, ...
                                             operators, ...
                                             binSize) 
    try
        combinedVoi = combineVoisFromJava( rtStruct, roiNames, operators, referenceImage );
    catch
        dvhJson = createDoseVolumeHistogramDto(DoseVolumeHistogram());
        warning('dataWrapper:createDvh', ['Could not generate bitmask for ROI ' roiNames{i}])
        return;
    end
    
    try
        doseVoi = createImageDataForVoi(combinedVoi, referenceDose);
        dvh = DoseVolumeHistogram(doseVoi, binSize);
        dvhJson = createDoseVolumeHistogramDto(dvh);
    catch
        dvhJson = createDoseVolumeHistogramDto(DoseVolumeHistogram());
        warning('dataWrapper:createDvh', 'something went wrong will applying dose to VOI')
        return;
    end
end        