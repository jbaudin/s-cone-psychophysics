classdef Parameters < SConePsychophysics.Utils.Parameters
    properties
        backgroundIntensity % will define the
        peakIntensity
        
        frequency % in Hz
        
        offsetStepSize % in radians
        maxOffset % in radians
        minOffset % in radians
        
        radius % in pixels???
    end
    
    properties (Dependent)
        backgroundIntensity8Bit
        darkIntensity8Bit
    end
    
    methods
        function value = get.backgroundIntensity8Bit(obj)
            value = round(obj.backgroundIntensity * 255);
        end
        
        function value = get.darkIntensity8Bit(obj)
            value = round(obj.darkIntensity * 255);
        end
    end
    
    methods (Static)
        function parameters = DebugExample()
            parameters = SConePsychophysics.StimulusGenerators.Flicker.Parameters();
            parameters.backgroundIntensity = 0.5;
            parameters.peakIntensity = 1;
            parameters.frequency = 1;
            parameters.offsetStepSize = 0.1;
            parameters.maxOffset = 3;
            parameters.minOffset = -3;
            parameters.radius = 100;
        end
    end
end