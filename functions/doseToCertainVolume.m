%DVH info:
% the dose to 95% of the considered volume (D95) 
% SOURCE: http://ro-journal.biomedcentral.com/articles/10.1186/1748-717X-4-44
function out = doseToCertainVolume(doseCube, pixelSpacing, volumeLimit, volumeLimitPercentage, volume, dosePercentage, targetPresriptionDose)
    
    %% input parsing
    if ~isnumeric(doseCube);
        throw(MException('doseToCertainVolume:InputTypeMismatch','doseCube should be numeric matrix'));
    end
    
    if ~isnumeric(pixelSpacing);
        throw(MException('doseToCertainVolume:InputTypeMismatch','pixelSpacing should be numeric vector'));
    end
    
    if length(size(doseCube)) ~= length(pixelSpacing)
        throw(MException('doseToCertainVolume:InputDimensionMismatch','pixelSpacing should represent each doseCube dimension in a one-dimensional numeric array'));
    end
    
    if ~isnumeric(volumeLimit);
        throw(MException('doseToCertainVolume:InputTypeMismatch','doseCube should be numeric matrix'));
    end
    
    if ~islogical(volumeLimitPercentage) && length(volumeLimitPercentage) == 1
        throw(MException('doseToCertainVolume:InputTypeMismatch','volumeLimitPercentage should be true/false'));
    end
    
    if ~isnumeric(volume) && length(volume) == 1
        throw(MException('doseToCertainVolume:InputTypeMismatch','volume should be double'));
    end
    
    if ~islogical(dosePercentage) && length(dosePercentage) == 1
        throw(MException('doseToCertainVolume:InputTypeMismatch','dosePercentage should be true/false'));
    end
    
    if dosePercentage
        if ~isnumeric(targetPresriptionDose) && length(targetPresriptionDose) == 1
            throw(MException('doseToCertainVolume:InputTypeMismatch','doseCube should be double'));
        end
    end
    
    %% processing
    if volumeLimitPercentage
        volumeLimit = volume*(volumeLimit/100);
    end    

    %max value is added 2 times at beginning, because zero is
    %added before dose vector
    doseMatrix  = doseCube(~isnan(doseCube));
    doseVect    = sort([0; doseMatrix(:)], 'ascend');
    volumeVect  = [volume, volume:-prod(pixelSpacing):prod(pixelSpacing)];
    out         = doseVect(find(volumeVect <= volumeLimit, 1,'first'));
    %take the first one because they all have the dose criteria
    
    if dosePercentage
        out = out / targetPresriptionDose * 100;
    end
end

