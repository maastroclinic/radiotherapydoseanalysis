% CALCULATEBITMASKVOLUME calculate a volume using a bitmask representation
%   of a concept and the real world unities of the pixels
%   
%   VOLUME = CALCULATEBITMASKVOLUME(BITMASK, PIXELSPACING) calculdate
%       volume using logical matrix BITMASK and numeric array PIXELSPACING.
%   volume unity is determined by the pixelSpacing dimensions, user of this
%       function should be aware of this dependancy and determine the unity of
%       the resulting volume
%
%   See also 
function volume = calculateBitmaskVolume(bitmask, pixelSpacing)
    
    %% input parsing
    if ~islogical(bitmask);
        throw(MException('calculateBitmaskVolume:InputTypeMismatch','bitmask should be logical array'));
    end
    
    if ~isnumeric(pixelSpacing);
        throw(MException('calculateBitmaskVolume:InputTypeMismatch','pixelSpacing should be numeric array'));
    end
    
    if length(size(bitmask)) ~= length(pixelSpacing)
        throw(MException('calculateBitmaskVolume:InputDimensionMismatch','pixelSpacing should represent each bitmask dimension in a one-dimensional numeric array'));
    end
    
    %% processing
    volume = nansum(bitmask(:)) * prod(pixelSpacing);
end