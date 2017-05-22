classdef HardwareParameters < SConePsychophysics.Utils.Parameters
    properties
        window
        width
        height
        frameDuration
        renderInQuadrants % boolean
        backgroundIntensity
    end
    
    properties (Dependent)
        theoreticalRefreshRate
        theoreticalFrameDuration
        frameWidth
        frameHeight
    end
    
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