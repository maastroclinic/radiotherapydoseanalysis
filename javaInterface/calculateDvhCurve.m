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
        doseCube = doseCube(~isnan(doseCube));
        sortedDose = sort(doseCube(:), 'ascend');
        
        %sortedDose = sort([0; doseCube(:)], 'ascend');
        %very hard because this is a physics thing, but in my theoretical unit test
        % the 0 resulted in an error, because an addition voxel is created.
        % want to leave this in for documentation purposes!
        
        vDose   = (0:binSize:(sortedDose(end)+binSize));
        vVolume = zeros(length(vDose),1);

        voxelCount = 0;
        for i = length(vDose):-1:1
            newVoxelList = find(sortedDose >= vDose(i));
            voxelCount = voxelCount + (length(newVoxelList));
            vVolume(i) = voxelCount;
            sortedDose(newVoxelList) = [];
        end
        vVolume = vVolume .* prod(pixelSpacing);
        
        if relative
            vVolume = vVolume / volume * 100;
        end
    catch EM
        warning('calculateDvhCurve:calculationError', EM.message);
        vVolume = NaN;
        vDose   = NaN;
    end
end

