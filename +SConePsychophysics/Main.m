function Main(stimulusParameters, generator, savePath, varargin)
% parse the inputs
ip = inputParser();
ip.addOptional('DebugMode', false, @(x) islogical(x));
ip.addOptional('DebugModeScreen', 0, @(x) isnumeric(x) && numel(x) == 1 && x>= 0 && x == round(x));
ip.addOptional('DebugModeFullscreen', false, @(x) islogical(x));
ip.addOptional('DebugModeScreenRectangle', [0 0 640 480], @(x) isnumeric(x) && numel(x) == 4 && all(x >= 0)); 
ip.addOptional('RenderInQuadrants', true, @(x) islogical(x));
isPositiveNumber = @(x) isnumeric(x) && numel(x) == 1 && x > 0;
ip.addOptional('KeyboardCheckInterval', 0.250, isPositiveNumber); % in seconds
ip.addOptional('MaxRunTime', 60, @(x) @(x) isnumeric(x) && numel(x) == 1 && x > 0); % in seconds
ip.parse(varargin{:});

% initialize things for Datapixx (if not debugging), Psychimaging, Window
% as hardware is initialized, add data to hardware properties
hardwareParameters = SConePsychophysics.Utils.HardwareParameters();
SConePsychophysics.Utils.Initialization.Datapixx(hardwareParameters, ...
    'DebugMode', ip.Results.DebugMode, 'RenderInQuadrants', ip.Results.RenderInQuadrants);
SConePsychophysics.Utils.Initialization.PsychImaging();
SConePsychophysics.Utils.Initialization.Window(hardwareParameters, ...
    'DebugMode', ip.Results.DebugMode, ...
    'DebugModeScreen', ip.Results.DebugModeScreen, ...
    'DebugModeFullscreen', ip.Results.DebugModeFullscreen, ...
    'DebugModeScreenRectangle', ip.Results.DebugModeScreenRectangle);

% create the stimuli, stimulus generator will return the appropriate cycler
cycler = generator(stimulusParameters, hardwareParameters);

% run the experiment
results = SConePsychophysics.RunExperiment(cycler, ip.Results.KeyboardCheckInterval, ip.Results.MaxRunTime);

% close psychtoolbox
Screen('CloseAll');

% save the parameters and results
hardwareParameters.Save(fullfile(savePath, 'hardwareParametesr.txt'));
stimulusParameters.Save(fullfile(savePath, 'stimulusParameters.txt'));
results.Save(fullfile(savePath, 'results.txt'));
end