function combinedVoi = combineVoisFromJava( rtStruct, roiNames, operators, referenceImage )
    contour = createContour(rtStruct, roiNames{1});
    voi = createVolumeOfInterest(contour, referenceImage);
    combinedVoi = voi;

    for i = 2:length(roiNames)

        contour = createContour(rtStruct, roiNames{i});
        voi = createVolumeOfInterest(contour, referenceImage);
        isValidVoi(voi,roiNames{i})
        combinedVois = combineVois(combinedVois, voi, operators{i - 1});

    end
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