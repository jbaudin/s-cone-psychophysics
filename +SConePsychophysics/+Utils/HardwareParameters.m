classdef HardwareParameters < SConePsychophysics.Utils.Parameters
    properties
        window
        width
        height
        frameDuration
        renderInQuadrants % boolean
    end
    
    properties (Dependent)
        theoreticalRefreshRate
        theoreticalFrameDuration
    end
    
    methods
        function value = get.theoreticalRefreshRate(obj)
            actualRefreshRate = 1 / obj.frameDuration;
            value = round(actualRefreshRate);
        end
        
        function value = get.theoreticalFrameDuration(obj)
            value = 1 / obj.theoreticalRefreshRate;
        end
    end
end