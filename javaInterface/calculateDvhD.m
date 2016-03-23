%CALCULATEDVHD
%TODO
function [ dParam ] = calculateDvhD(vVolume, vDose, volumeLimit, volumeLimitPercentage, volume, dosePercentage, targetPresriptionDose)
    
    %% input parsing
    if ~isnumeric(vDose);
        throw(MException('doseToCertainVolume:InputTypeMismatch','doseCube should be numeric matrix'));
    end
    
    if ~isnumeric(vVolume);
        throw(MException('doseToCertainVolume:InputTypeMismatch','pixelSpacing should be numeric vector'));
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
    try     
        if volumeLimitPercentage
            volumeLimit = volume*(volumeLimit/100);
        end    

        dParam = vDose(find(vVolume <= volumeLimit, 1,'first'));
        %take the first one because they all have the dose criteria

        if dosePercentage
            dParam = dParam / targetPresriptionDose * 100;
        end
    catch EM
        warning('calculateDvhV:calculationError', EM.message)
    end
end

