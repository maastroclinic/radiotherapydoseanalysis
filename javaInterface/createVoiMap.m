%CREATEVOIMAP provides Java with the necessary VOIS to perform
%calculations with CALCULATESTRUCTEDATAWRAPPER. To shorten computation
%times this load was split from the calculations

%   See also ROIVOLUME, RTSTRUCT, CT, CALCULATIONGRID.
%   Software Development Team MAASTRO CLinic.

function vois = createVoiMap(pathStruct, ...
                                referenceImage, ...
                                volumeNames)    
    if ~exist(pathStruct, 'file')
        EM = MException('matlabData:MissingParamater', 'A RT-STRUCT file was not correctly specified');
        throw(EM);
    end

    if isempty(volumeNames)
        EM = MException('matlabData:MissingParamater', 'No Volume names provided');
        throw(EM);
    end

    struct = RtStruct(pathStruct, true);

    j = 0;
    vois = containers.Map;
    for i = 1:length(volumeNames)
        try
            contour = createContour(struct, volumeNames{i});
            voi = createVolumeOfInterest(contour, referenceImage);
            vois(volumeNames{i}) = voi;
            j = j + 1;
        catch
            warning('dataWrapper:rtStruct', ['Could not generate bitmask for ROI ' volumeNames{i}])
        end
    end
end