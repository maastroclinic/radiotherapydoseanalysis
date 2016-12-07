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
    
    contour = createContour(rtStruct, roiNames{1});
    voi = createVolumeOfInterest(contour, referenceImage);
    combinedVoi = voi;
    
    for i = 2:length(roiNames)
        try
            contour = createContour(rtStruct, roiNames{i});
            voi = createVolumeOfInterest(contour, referenceImage);
            isValidVoi(voi,roiNames{i})
            combinedVois = combineVois(combinedVois, voi, operators{i - 1});
        catch
            dvhJson = createDoseVolumeHistogramDto(DoseVolumeHistogram());
            warning('dataWrapper:createDvh', ['Could not generate bitmask for ROI ' roiNames{i}])
            return;
        end
    end
    doseVoi = createImageDataForVoi(combinedVoi, referenceDose);
    dvh = DoseVolumeHistogram(doseVoi, binSize);
    dvhJson = createDoseVolumeHistogramDto(dvh);
end

function combinedVoi = combineVois(combinedVoi, voi, operator)
    if(strcmp(operator,'+'))
        combinedVoi = addVois(combinedVoi, voi);
    elseif(strcmp(operator,'-'))
        combinedVoi = subtractVois(combinedVoi, voi);
    else
        throw(MException('dataWrapper:createDvh','operator not recognized'));
    end
end

function isValidVoi(voi,roiName)
    if isempty(voi)
        throw(MException('Matlab:createDoseVolumeHistogram:invalidData', ['contour ' roiName ' is not a valid contour']))
    end
end            