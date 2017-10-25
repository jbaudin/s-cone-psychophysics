% This is a class to manage a Psychtoolbox session.  It allows the creation
% and management of a session to be separated from the functions that
% display stimuli for an experiment.  This will facilitate being able to
% run multiple consecutive experiments without having to close and reopen a
% psychtoolbox window.

classdef PsychtoolboxSession < handle
    properties
        % a SConePsychophysics.Utils.HardwareParameters object that will
        % store all relevant information about the hardware setup
        hardwareParameters
    end
    
    methods
        function obj = PsychtoolboxSession(varargin)
            ip = inputParser();
            % boolean controlling whether or not the screen will be
            % manually specified (by default it will choose the screen with
            % the largest id)
            ip.addOptional('SpecifyScreen', false, @(x) islogical(x));
            % integer for the screen id of the screen to use (this will
            % only be used if 'SpecifyScreen' is true
            ip.addOptional('Screen', 0, @(x) isnumeric(x) && numel(x) == 1 && x>= 0 && x == round(x));
            % boolean controlling debug mode (which will give some more
            % freedom over screen placement, size, etc.)
            ip.addOptional('DebugMode', false, @(x) islogical(x));
            % boolean for whether or not to use a fullscreen dispaly (to
            % use a less than full screen display, 'DebugMode' must be
            % true); this is convenient for debugging away from the rig
            ip.addOptional('DebugModeFullscreen', false, @(x) islogical(x));
            % array of [left top width height] for the non-fullscreen
            % rectangle in which to display the stimulus (only in debug
            % mode)
            ip.addOptional('DebugModeScreenRectangle', [0 0 640 480], @(x) isnumeric(x) && numel(x) == 4 && all(x >= 0));
            % controls whether or not he stimulus is rendered in quadrants
            % (required for the actual psychophysics rig, but can be set to
            % false if only one frame is desired while debugging)
            ip.addOptional('RenderInQuadrants', true, @(x) islogical(x));
            % number, or 3 element array in range [0 1] controlling the
            % background of the PsychToolbox window
            ip.addOptional('BackgroundIntensity', SConePsychophysics.Constants.BACKGROUND_INTENSITY, ...
                @(x) isnumeric(x) && all(x <= 1 & x >= 0));
            ip.parse(varargin{:});
            
            % initialize things for Datapixx (if not debugging), Psychimaging, Window
            % as hardware is initialized, add data to hardware properties
            
            % create the hardware parameters object so that it can be
            % filled out as different things are intialized
            obj.hardwareParameters = SConePsychophysics.Utils.HardwareParameters();
            % set the current background so that it will be correct upon
            % initialization
            obj.SetBackground(ip.Results.BackgroundIntensity);
            
            % add the value of RenderInQuadrants to the hardware parameters
            % (will be used during Datapixx initialization)
            obj.hardwareParameters.renderInQuadrants = ip.Results.RenderInQuadrants;
            
            % if not in debug mode, initialize Datapixx
            if ~ip.Results.DebugMode
                SConePsychophysics.Utils.Initialization.Datapixx(obj.hardwareParameters, 'DebugMode', ip.Results.DebugMode);
            end
            
            % create the window
            SConePsychophysics.Utils.Initialization.Window(obj.hardwareParameters, ...
                ip.Results.SpecifyScreen, ip.Results.Screen, ip.Results.DebugMode, ip.Results.DebugModeFullscreen, ...
                ip.Results.DebugModeScreenRectangle);
        end
        
        function SetBackground(obj, background)
            % this function sets the background intensity of the window
            % after checking to make sure it will be in the bounds of the
            % monitor; it does not actually cause the display to show this
            % background immediately, only the next time it changes to
            % showing the background; to force this change, call the
            % Clear() method
            if SConePsychophysics.Utils.IsWithinMonitorBounds(background)
                obj.hardwareParameters.backgroundIntensity = background;
            else
                error('The requested background is not within the bounds of the monitor');
            end
        end
        
        function Clear(obj)
            % causes the window to be filled with the background color
            Screen('FillRect', obj.hardwareParameters.window, obj.hardwareParameters.backgroundIntensity, ...
                Screen('Rect', obj.hardwareParameters.window));
            Screen('Flip', obj.hardwareParameters.window);
        end
        
        function Close(obj)
            % closes the PsychToolbox window
            Screen('Close', obj.hardwareParameters.window);
        end
    end
end