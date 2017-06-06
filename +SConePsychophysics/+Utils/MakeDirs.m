function MakeDirs(varargin)
for i = 1:numel(varargin)
    if ~isdir(varargin{i})
        mkdir(varargin{i});
    end
end
end