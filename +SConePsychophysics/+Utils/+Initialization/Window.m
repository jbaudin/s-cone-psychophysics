function Window(hardwareParameters)
% get the screenid - depending on configuration, this could need changing
screenId = max(Screen('Screens'));

% open window for the specified screen
defaultWindowColor = SConePsychophysics.Constants.BACKGROUND_INTENSITY * 255;
hardwareParameters.window = PsychImaging('OpenWindow', screenId, defaultWindowColor);

% add the window width and height to the hardware parameters
[hardwareParameters.width, hardwareParameters.height] = Screen('WindowSize', hardwareParameters.window);

% add refresh rate to hardwareParameters
hardwareParameters.frameDuration = Screen('GetFlipInterval', hardwareParameters.window);
end