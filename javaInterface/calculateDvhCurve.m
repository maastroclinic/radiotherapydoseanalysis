%%CALCULATEDVHCURVE
function gtv1Dvh = calculateDvhCurve(doseCube, binSize, relative)   
    if ~isnumeric(binSize) && length(binSize) == 1
        throw(MException('calculateDvhCurve:InputTypeMismatch','binSize should be single numeric value'));
    end
    
    if ~islogical(relative) && length(relative) == 1
        throw(MException('calculateDvhCurve:InputTypeMismatch','relative should be single logical'));
    end
    
    %% processing
    try 
        gtv1Dvh = DoseVolumeHistogram(doseCube, binSize);
    catch EM
        warning('calculateDvhCurve:calculationError', EM.message);
    end
end

