classdef Results < handle
    properties (Access = protected)
        results
    end
    
    methods
        function obj = Results()
            obj.results = containers.Map('KeyType', 'char', 'ValueType', 'any');
        end
        
        function Add(obj, key, value)
            obj.results(key) = value;
        end
        
        function Save(obj, savePath)
            fileID = fopen(savePath, 'w');
            SConePsychophysics.Utils.PrintKeyValuePairsToFile(fileID, obj.results.keys(), @(x) obj.results(x), ...
                'AddDate', true);
            fclose(fileID);
        end
    end
end