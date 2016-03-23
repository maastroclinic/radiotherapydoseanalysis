%%CALCULATEDVHCURVE
%TODO
function [ vVolume, vDose ] = calculateDvhCurve(doseCube, binSize, pixelSpacing, relative, volume)
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
    
    if relative
        if ~isnumeric(volume) && length(volume) == 1
            throw(MException('calculateDvhCurve:InputTypeMismatch','volume should be single numeric value'));
        end
    end
    
    %% processing
    try 
        vVolume = NaN;
        vDose   = NaN;

        doseCube = doseCube(~isnan(doseCube));
        sortedDose = sort([0; doseCube(:)], 'ascend');
        vDose   = (0:binSize:max(max(max(doseCube)))+binSize); %sortedDose(end)?
        vVolume = zeros(length(vDose),1);

        for i = 1 : length(vDose)
            tmp = find(sortedDose >= vDose(i));
            vVolume(i) = (length(tmp)*prod(pixelSpacing));
        end
        
        if relative
            vVolume = vVolume / volume * 100;
        end
    catch EM
        warning('calculateDvhCurve:calculationError', EM.message)
    end
end

