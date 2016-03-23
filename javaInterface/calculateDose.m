%%CALCULATEDOSE 
%*TODO*
function [ dose ] = calculateDose(doseCube, operation)
    %% input parsing
    if ~isnumeric(doseCube);
        throw(MException('calculateDose:InputTypeMismatch','image should be numeric array'));
    end
    
    if ~ischar(operation);
        throw(MException('calculateDose:InputTypeMismatch','operation should be character array'));
    end

    %% processing
    dose = NaN;
    try
        switch strtrim(lower(operation))
            case 'mean'
                dose = nanmean(doseCube(:));
            case 'max'
                dose = nanmax(doseCube(:));
            case 'min'
                dose = nanmin(doseCube(:));
            otherwise
                throw(MException('calculateDose:InvalidInput','invalid operation'));
        end    
    catch EM
        warning('calculateDose:unknownError', EM.message);
    end  
end

