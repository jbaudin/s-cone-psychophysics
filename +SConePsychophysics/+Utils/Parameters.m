classdef Parameters < handle
    methods
        function Save(obj, savePath)
            propertyNames = properties(obj);
            fileID = fopen(savePath, 'w');
            %             SConePsychophysics.Utils.PrintKeyValuePairsToFile(fileID, propertyNames, @(x) obj.(x), ...
            SConePsychophysics.Utils.PrintKeyValuePairsToFile(fileID, propertyNames, @(x) x, ...
                'AddDate', true);
            fclose(fileID);
        end
    end
end
