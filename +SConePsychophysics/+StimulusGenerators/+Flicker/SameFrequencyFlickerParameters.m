% this is a wrapper for flicker parameters
classdef SameFrequencyFlickerParameters
    properties
        backgroundIntensity % will define the
        peakIntensity
        
        frequency % in Hz
        
        offsetStepSize % in radians
        maxOffset % in radians
        minOffset % in radians
        
        radius % in pixels???
    end
    
    
    methods
        function parameters = Build(obj)
            parameters = SConePsychophysics.StimulusGenerators.Flicker.Parameters();
            parameters.backgroundIntensityR = obj.backgroundIntensity;
            parameters.peakIntensityR = obj.peakIntensity;
            
            parameters.backgroundIntensityG = obj.backgroundIntensity;
            parameters.peakIntensityG = obj.peakIntensity;
            
            parameters.backgroundIntensityB = obj.backgroundIntensity;
            parameters.peakIntensityB = obj.peakIntensity;
            
            parameters.frequencyR = obj.frequency;
            parameters.frequencyG = obj.frequency;
            parameters.frequencyB = obj.frequency;
            
            parameters.offsetStepSize  = obj.offsetStepSize;
            parameters.maxOffset  = obj.maxOffset;
            parameters.minOffset = obj.minOffset;
            
            parameters.radius = obj.radius;
        end
    end
    
    methods (Static)
        function parameters = DebugExample()
            parameters = SConePsychophysics.StimulusGenerators.Flicker.SameFrequencyFlickerParameters();
            parameters.backgroundIntensity = 128;
            parameters.peakIntensity = 255;
            
            parameters.frequency = 1;
            
            parameters.offsetStepSize = 0.1;
            parameters.maxOffset = 3;
            parameters.minOffset = -3;
            parameters.radius = 100;
        end
    end
end
