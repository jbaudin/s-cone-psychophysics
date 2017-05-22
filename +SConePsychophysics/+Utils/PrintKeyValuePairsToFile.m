function PrintKeyValuePairsToFile(fileID, keys, valueGetFxn, varargin)
ip = inputParser();
ip.addParameter('Title', '', @(x) isempty(x) || ischar(x));
ip.addParameter('AddDate', false, @(x) islogical(x));
ip.parse(varargin{:});

if ~isempty(ip.Results.Title)
    fprintf(fileID, '%s\n', ip.Results.Title);
end

if ip.Results.AddDate
    fprintf(fileID, 'Date: %s\n', char(datetime()));
end

for i = 1:numel(keys)
    currKey = keys{i};
    currValue = valueGetFxn(currKey);
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
        case 'cell'
            formatSpec = '%s';
            currValue = CellToString(currValue);
    end
    
    % do the actual printing
    fprintf(fileID, ['%s: ' formatSpec '\n'], currKey, currValue);
    
end

    function str = CellToString(cellArray)
        content = strjoin(cellfun( ...
            @(x) ['[' strjoin(arrayfun( ...
            @(y) num2str(y), x, ...
            'UniformOutput', false)) ']'], cellArray, 'UniformOutput', false), ', ');
        str = ['{' content '}'];
    end
end