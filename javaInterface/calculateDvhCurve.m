%%CALCULATEDVHCURVE
function [ vVolume, vDose ] = calculateDvhCurve(doseCube, binSize, relative)
    %% input parsing
    if ~isnumeric(doseCube)
        throw(MException('calculateDvhCurve:InputTypeMismatch','doseCube should be numeric matrix'));
    end
    
    if ~isnumeric(binSize) && length(binSize) == 1
        throw(MException('calculateDvhCurve:InputTypeMismatch','binSize should be single numeric value'));
    end
    
    if ~isnumeric(pixelSpacing)
        throw(MException('calculateDvhCurve:InputTypeMismatch','pixelSpacing should be numeric array'));
    end
    
    if ~islogical(relative) && length(relative) == 1
        throw(MException('calculateDvhCurve:InputTypeMismatch','relative should be single logical'));
    end
    
    %% processing
    try 
        gtv1Dvh = DoseVolumeHistogram(doseCube, binSize);
        vDose = gtv1Dvh.vDose;
        
        if relative
            vVolume = gtv1Dvh.vVolumeRelative;
        else
            vVolume = gtv1Dvh.vVolume;
        end
    catch EM
        warning('calculateDvhCurve:calculationError', EM.message);
        vVolume = NaN;
        vDose   = NaN;
    end
end

