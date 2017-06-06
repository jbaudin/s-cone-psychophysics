% This function opens a Psychtoolbox window and adds all relevant
% information to the hardwdare parameters.  The window it creates will
% depend on many different inputs.  If currently not in debug mode, it will
% always create a fullscreen window.  If specifyScreen is true, it will
% make the window in whichever screen is specified by the integer input
% screen.  If specifyScreen is false, it will use Psychtoolbox to search
% for available screens and take the one with the highest identifier
% (Psychtoolbox identifies screens using integers). This highest identifier
% approach should find the Datapixx by default.  If debug mode is true, it
% will make either a fullscreen or not fullscreen window (depending on the
% value of debugModeFullscreen).  If making a fullscreen window in debug
% mode, it always takes the value in the input 'screen'.  If making a non-fullscreen 
% window, the rectangle in which the screen will appear is specified by 
% debugModeScreenRectangle, but in this case, specifyScreen and screen will 
% not impact which screen will be used (because specifying a window location 
% with a rectangle in Psychtoolbox overrides a screen selection).  
%
% Inputs:
%       hardwareParameters: HardwareParameters object to which all of the
%               relevant hardware information will be added
%       specifyScreen: boolean determining whether or not to take screen
%               specified by next input argument
%       screen: integer identifier of screen to use (only used if
%               specifyScreen is true)
%       debugMode: boolean controlling whether or not debug mode is on
%       debugModeFullscreen: boolean controlling whether or not to use a
%               fullscreen in debug mode
%       debugModeScreenRectangle: 4 element array specifying where to place
%               the window (only used if debugModeFullscreen is false),
%               values are (in pixels): [left, top, width, height].

function Window(hardwareParameters, specifyScreen, screen, debugMode, debugModeFullscreen, debugModeScreenRectangle)

% determine the screen identifier (an integer used by Psychtoolbox to
% identify a given screen)
if debugMode
    % if debug mode, take the value specified in screen
    screenId = screen;
else
    % if not in debug mode, if specifyScreen is true, take the screen that
    % was specified in the input 'screen'; if specifyScreen is false, take
    % the screen with the maximum identifier (should find Datapixx if
    % present).
    if specifyScreen
        % check to make sure the specified screen is actually a screen
        if ~any(Screen('Screens') == screen)
            error(['The screen with the identifider: ' num2str(screen) ' was requested but cannot be found.']);
        end
        
        screenId = screen;
    else
        screenId = max(Screen('Screens'));
    end
end

% if in debugModea, and not fullscreen, use the rectangle provided for the
% window, if not leave it empty (which causes Psychtoolbox to default to a
% full screen presentation)
if debugMode && ~debugModeFullscreen
    windowRectangle = debugModeScreenRectangle;
else
    windowRectangle = [];
end

% prepare setup of imaging pipeline for onscreen window
PsychImaging('PrepareConfiguration');
% setup framebuffer
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
% have the color range be between 0 and 1
PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange');

% open window for the specified screen
hardwareParameters.window = PsychImaging( ...
    'OpenWindow', screenId, hardwareParameters.backgroundIntensity, windowRectangle);

% add the window width and height to the hardware parameters
[hardwareParameters.width, hardwareParameters.height] = Screen('WindowSize', hardwareParameters.window);

% add refresh rate to hardwareParameters
hardwareParameters.frameDuration = Screen('GetFlipInterval', hardwareParameters.window);
end