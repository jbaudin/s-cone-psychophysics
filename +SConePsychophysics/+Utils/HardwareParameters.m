% This is a class to hold on to all of the hardware parameters and ease
% passing them around from function to function.  It also keeps them in one
% place to make it easy to save them all at the end of an experiment

classdef HardwareParameters < SConePsychophysics.Utils.Parameters
    properties
        % Psychtoolbox identifier of the window being used
        window
        % width (in pixels) of the window
        width
        % height (in pixels) of the window
        height
        % frame duration (in seconds), this will be the actual value
        % returned from Psychtoolbox, not the rounded theoretical value
        frameDuration
        % boolean whether or not to render the stimulus in quadrants or
        % just a single stimulus in the center
        renderInQuadrants
        % the background intensity (0 - 1 range) for the psychotoolbox
        % window
        backgroundIntensity
    end
    
    properties (Dependent)
        % theoretical (i.e., rounded) refresh rate for the monitor
        theoreticalRefreshRate
        % theoretical frame duration (i.e., the inverse of the
        % theoreticalRefreshRate
        theoreticalFrameDuration
        % width of a frame (based on whether or not stimuli are rendered in
        % quadrants)
        frameWidth
        % height of a frame (based on whether or not stimuli are rendered
        % in quadrants)
        frameHeight
    end
    
    % these are the methods to calculate all of the dependent properties
    % listed above
    methods
        function value = get.theoreticalRefreshRate(obj)
            actualRefreshRate = 1 / obj.frameDuration;
            value = round(actualRefreshRate);
        end
        
        function value = get.theoreticalFrameDuration(obj)
            value = 1 / obj.theoreticalRefreshRate;
        end
        
        function value = get.frameWidth(obj)
            value = obj.width / (1 + obj.renderInQuadrants);
        end
        
        function value = get.frameHeight(obj)
            value = obj.height / (1 + obj.renderInQuadrants);
        end
    end
end