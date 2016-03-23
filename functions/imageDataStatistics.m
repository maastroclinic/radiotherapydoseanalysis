function out = imageDataStatistics(image, operation)

    %% input parsing
    if ~isnumeric(image);
        throw(MException('imageDataStatistics:InputTypeMismatch','image should be numeric array'));
    end
    
    if ~ischar(operation);
        throw(MException('imageDataStatistics:InputTypeMismatch','operation should be character array'));
    end

    %% processing
    switch strtrim(lower(operation))
        case 'mean'
            out = nanmean(image(:));
        case 'max'
            out = nanmax(image(:));
        case 'min'
            out = nanmin(image(:));
        otherwise
            throw(MException('imageDataStatistics:InvalidInput','invalid operation'));
    end
end

