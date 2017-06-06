% A superclass for parameters classes.  It contains a Save method to save
% all of the properties of the class.

classdef Parameters < handle
    methods
        function Save(obj, savePath)
            propertyNames = properties(obj);
            fileID = fopen(savePath, 'w');
            SConePsychophysics.Utils.PrintKeyValuePairsToFile(fileID, propertyNames, @(x) obj.(x), ...
                'AddDate', true);
            fclose(fileID);
        end
    end
end
