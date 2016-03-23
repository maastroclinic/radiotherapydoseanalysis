%CALCULATEDVHV
%TODO
function [ vParam ] = calculateDvhV(doseCube, pixelSpacing, doseLimit, relative, volume)
    
     %% input parsing
    if ~isnumeric(doseCube);
        throw(MException('doseToCertainVolume:InputTypeMismatch','doseCube should be numeric matrix'));
    end
    
    if ~isnumeric(doseLimit) && length(doseLimit) == 1
        throw(MException('doseToCertainVolume:InputTypeMismatch','doseLimit should be single numeric value'));
    end
    
    if ~isnumeric(pixelSpacing);
        throw(MException('doseToCertainVolume:InputTypeMismatch','pixelSpacing should be numeric vector'));
    end
    
    if length(size(doseCube)) ~= length(pixelSpacing)
        throw(MException('doseToCertainVolume:InputDimensionMismatch','pixelSpacing should represent each doseCube dimension in a one-dimensional numeric array'));
    end
    
     if ~islogical(relative) && length(relative) == 1
        throw(MException('calculateDvhCurve:InputTypeMismatch','relative should be single logical'));
    end
    
    if relative
        if ~isnumeric(volume) && length(volume) == 1
            throw(MException('calculateDvhCurve:InputTypeMismatch','volume should be single numeric value'));
        end
    end
    
    %% processing
    vParam = NaN;
    
    try 
        vParam = length(find(doseCube(:) >= doseLimit)) * prod(pixelSpacing);
        if relative
            vParam = vParam / volume * 100;
        end
    catch EM
        warning('calculateDvhV:calculationError', EM.message)
    end
end

