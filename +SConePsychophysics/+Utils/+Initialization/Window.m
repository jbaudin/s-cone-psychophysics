function Window(hardwareParameters, varargin)
ip = inputParser();
ip.addOptional('DebugMode', false, @(x) islogical(x));
ip.addOptional('DebugModeScreen', 0, @(x) isnumeric(x) && numel(x) == 1 && x >= 0 && round(x) == x);
ip.parse(varargin{:});

% get the screenid - can be overriden by placing in debug mode
if ip.Results.DebugMode
    screenId = ip.Results.DebugModeScreen;
else
    screenId = max(Screen('Screens'));
end

% open window for the specified screen
defaultWindowColor = SConePsychophysics.Constants.BACKGROUND_INTENSITY * 255;
hardwareParameters.window = PsychImaging('OpenWindow', screenId, defaultWindowColor);

% add the window width and height to the hardware parameters
[hardwareParameters.width, hardwareParameters.height] = Screen('WindowSize', hardwareParameters.window);

% add refresh rate to hardwareParameters
hardwareParameters.frameDuration = Screen('GetFlipInterval', hardwareParameters.window);
end