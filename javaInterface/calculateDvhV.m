%CALCULATEDVHV
%TODO
function [ vParam ] = calculateDvhV(vVolume, vDose, doseLimit, relative, volume)
    
     %% input parsing
    if ~isnumeric(vVolume);
        throw(MException('doseToCertainVolume:InputTypeMismatch','doseCube should be numeric matrix'));
    end
    
    if ~isnumeric(vDose);
        throw(MException('doseToCertainVolume:InputTypeMismatch','doseCube should be numeric matrix'));
    end
    
    if ~isnumeric(doseLimit) && length(doseLimit) == 1
        throw(MException('doseToCertainVolume:InputTypeMismatch','doseLimit should be single numeric value'));
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
        index = find((vDose(:) >= doseLimit), 1, 'first');
        vParam = vVolume(index);
        if relative
            vParam = vParam / volume * 100;
        end
    catch EM
        warning('calculateDvhV:calculationError', EM.message)
    end
end

