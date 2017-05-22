function Main(stimulusParameters, generator, session, savePath, varargin)
% parse the inputs
ip = inputParser();
isPositiveNumber = @(x) isnumeric(x) && numel(x) == 1 && x > 0;
ip.addParameter('KeyboardCheckInterval', 0.250, isPositiveNumber); % in seconds
ip.addParameter('MaxRunTime', 60, @(x) @(x) isnumeric(x) && numel(x) == 1 && x > 0); % in seconds
ip.parse(varargin{:});

% create the stimuli, stimulus generator will return the appropriate cycler
cycler = generator(stimulusParameters, session.hardwareParameters);

% run the experiment
results = SConePsychophysics.RunExperiment(cycler, ip.Results.KeyboardCheckInterval, ip.Results.MaxRunTime);

% clear the screen to its background
session.Clear();

% save the parameters and results
session.hardwareParameters.Save(fullfile(savePath, 'hardwareParameters.txt'));
stimulusParameters.Save(fullfile(savePath, 'stimulusParameters.txt'));
results.Save(fullfile(savePath, 'results.txt'));
end