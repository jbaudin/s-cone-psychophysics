% A function that prints a set of key/value pairs to a file. They wil be
% printed in the following format:
%           key: value
% Optionally can add a title to the file and/or the date
%
% inputs:
%       fileID: a fileID (returned from fopen in MATLAB); this is where the
%               key/value pairs will be written
%       keys: a cell array of key values
%       valueGetFxn: a function handle to a function that takes a key as an
%               input and returns its associated value
%       varargin: optional name/value arguments:
%           'Title':  a string to print as the title
%           'AddDate' a boolean controlling whether or not the date will be
%               added

function PrintKeyValuePairsToFile(fileID, keys, valueGetFxn, varargin)
% parse the optional inputs
ip = inputParser();
% a string for the title
ip.addOptional('Title', '', @(x) isempty(x) || ischar(x)); 
% a boolean controlling whether date is added
ip.addOptional('AddDate', false, @(x) islogical(x));
ip.parse(varargin{:});

% if specified, print the title
if ~isempty(ip.Results.Title)
    fprintf(fileID, '%s\n', ip.Results.Title);
end

% if specified, print the date
if ip.Results.AddDate
    fprintf(fileID, 'Date: %s\n', date);
end

% go through each key and print it and its value on separate lines
for i = 1:numel(keys)
    currKey = keys{i};
    currValue = valueGetFxn(currKey);
    currValueType = class(currValue);
    
    % determine the value type and get its format specification; if it is a
    % type that is not readily printed by fprintf, convert it to something
    % that is
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

    % convenience function to convert a cell arrary to a string (becuase
    % fprintf doesn't work with cell arrays)
    function str = CellToString(cellArray)
        content = strjoin(cellfun( ...
            @(x) ['[' strjoin(arrayfun( ...
            @(y) num2str(y), x, ...
            'UniformOutput', false)) ']'], cellArray, 'UniformOutput', false), ', ');
        str = ['{' content '}'];
    end
end