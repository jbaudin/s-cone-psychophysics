classdef PsychtoolboxSession < handle
    properties
        hardwareParameters
    end
    
    methods
        function obj = PsychtoolboxSession(varargin)
            ip = inputParser();
            ip.addParameter('SpecifyScreen', false, @(x) islogical(x));
            ip.addParameter('Screen', 0, @(x) isnumeric(x) && numel(x) == 1 && x>= 0 && x == round(x));
            ip.addParameter('DebugMode', false, @(x) islogical(x));
            ip.addParameter('DebugModeFullscreen', false, @(x) islogical(x));
            ip.addParameter('DebugModeScreenRectangle', [0 0 640 480], @(x) isnumeric(x) && numel(x) == 4 && all(x >= 0));
            ip.addParameter('RenderInQuadrants', true, @(x) islogical(x));
            ip.addParameter('BackgroundIntensity', SConePsychophysics.Constants.BACKGROUND_INTENSITY, ...
                @(x) isnumeric(x) && all(x <= 1 & x >= 0));
            ip.parse(varargin{:});
            
            % initialize things for Datapixx (if not debugging), Psychimaging, Window
            % as hardware is initialized, add data to hardware properties
            obj.hardwareParameters = SConePsychophysics.Utils.HardwareParameters();
            obj.hardwareParameters.backgroundIntensity = ip.Results.BackgroundIntensity;
            SConePsychophysics.Utils.Initialization.Datapixx(obj.hardwareParameters, ...
                'DebugMode', ip.Results.DebugMode, 'RenderInQuadrants', ip.Results.RenderInQuadrants);
            SConePsychophysics.Utils.Initialization.PsychImaging();
            SConePsychophysics.Utils.Initialization.Window(obj.hardwareParameters, ...
                ip.Results.SpecifyScreen, ip.Results.Screen, ip.Results.DebugMode, ip.Results.DebugModeFullscreen, ...
                ip.Results.DebugModeScreenRectangle);
        end
        
        function SetBackground(obj, background)
            obj.hardwareParameters.backgroundIntensity = background;
        end
        
        function Clear(obj)
            Screen('FillRect', obj.hardwareParameters.window, 255 * obj.hardwareParameters.backgroundIntensity, ...
                Screen('Rect', obj.hardwareParameters.window));
            Screen('Flip', obj.hardwareParameters.window);
        end
        
        function Close(obj)
            Screen('Close', obj.hardwareParameters.window);
        end
    end
end