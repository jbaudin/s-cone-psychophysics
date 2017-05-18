classdef Parameters < handle
    methods
        function Save(obj, savePath)
            propertyNames = properties(obj);
            fileID = fopen(savePath, 'w');
            
            % add a date/timestamp
            fprintf(fileID, 'Date: %s\n', char(datetime()));
            
            % add the property values
            for i = 1:numel(propertyNames)
               % get name, value, and type of current property
               currName = propertyNames{i};
               currValue = obj.(currName);
               currValueType = class(currValue);
               
               % print to file based on type
               switch currValueType
                   case 'char'
                       formatSpec = '%s';
                   case 'logical'
                       if currValue
                           currValue = 'true';
                       else
                           currValue = 'false';
                       end
                       formatSpec = '%s';
                   case {'uint8', 'uint16', 'uint32', 'uint64'}
                       formatSpec = '%i';
                   case 'double'
                       formatSpec = '%f';
               end
               
               % do the actual printing
               fprintf(fileID, ['%s: ' formatSpec '\n'], currName, currValue);
            end
            
            fclose(fileID);
        end
    end
end
