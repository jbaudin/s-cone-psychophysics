% A class that serves as a simple container to hold results.  Useful
% because it includes a built-in method to save those results.  Each added
% value will have a name (a string) and a value.
%
% Use it as follows:
%
% Create the results object:
%       myResults = SConePsychophysics.Utils.Results();
%
% Add a result, with a name of: someName and a value of: someValue:
%       myResults.Add(someName, someValue);
%
% Save the results to the file at the path: somePath:
%       myResults.Save(somePath);

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