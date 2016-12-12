function dvhJson = createDoseVolumeHistogramNoDose(rtStruct, ... 
                                             referenceImage, ...
                                             roiNames, ...
                                             operators) 
    try
        combinedVoi = combineVoisFromJava( rtStruct, roiNames, operators, referenceImage );
    catch
        dvhJson = createDoseVolumeHistogramDto(DoseVolumeHistogram());
        warning('dataWrapper:createDvh', 'Could not generate bitmask for ROIs ')
        return;
    end
    
    try
        dvh = DoseVolumeHistogram();
        dvh.volume = combinedVoi.volume;
        dvhJson = createDoseVolumeHistogramDto(dvh);
    catch
        dvhJson = createDoseVolumeHistogramDto(DoseVolumeHistogram());
        warning('dataWrapper:createDvh', 'something went wrong will applying dose to VOI')
        return;
    end
end