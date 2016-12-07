function dvhJson = createDoseVolumeHistogramNoDose(rtStruct, ... 
                                             referenceImage, ...
                                             roiNames, ...
                                             operators) 
    contour = createContour(rtStruct, roiNames{1});
    voi = createVolumeOfInterest(contour, referenceImage);
    combinedVoi = voi;
    
    for i = 2:length(roiNames)
        try
            contour = createContour(rtStruct, roiNames{i});
            voi = createVolumeOfInterest(contour, referenceImage);
            if(strcmp(operators{i - 1},'+'))
               combinedVoi = addVois(combinedVoi, voi);
            elseif(strcmp(operators{i - 1},'-'))
               combinedVoi = subtractVois(combinedVoi, voi);
            else
                throw(MException('dataWrapper:createDvh','operator not recognized'));
            end
        catch
            warning('dataWrapper:createDvh', ['Could not generate bitmask for ROI ' roiNames{i}])
        end
    end

    dvh = DoseVolumeHistogram();
    dvh.volume = combinedVoi.volume;
    dvhJson = createDoseVolumeHistogramDto(dvh);
end