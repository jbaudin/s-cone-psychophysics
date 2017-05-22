function Window(hardwareParameters, specifyScreen, screen, debugMode, debugModeFullscreen, debugModeScreenRectangle)


% get the screenid - can be overriden by placing in debug mode
if debugMode
    screenId = screen;
else
    if specifyScreen
        screenId = screen;
    else
        screenId = max(Screen('Screens'));
    end
end

if debugMode && ~debugModeFullscreen
    windowRectangle = debugModeScreenRectangle;
else
    windowRectangle = [];
end

% open window for the specified screen
defaultWindowColor = hardwareParameters.backgroundIntensity * 255;
hardwareParameters.window = PsychImaging('OpenWindow', screenId, defaultWindowColor, windowRectangle);

% add the window width and height to the hardware parameters
[hardwareParameters.width, hardwareParameters.height] = Screen('WindowSize', hardwareParameters.window);

% add refresh rate to hardwareParameters
hardwareParameters.frameDuration = Screen('GetFlipInterval', hardwareParameters.window);
end