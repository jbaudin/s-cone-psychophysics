classdef Parameters < SConePsychophysics.Utils.Parameters
    properties
        backgroundIntensityR % will define the
        peakIntensityR
        
        backgroundIntensityG % will define the
        peakIntensityG
        
        backgroundIntensityB % will define the
        peakIntensityB
        
        frequencyR % in Hz
        frequencyG % in Hz
        frequencyB % in Hz
        
        offsetStepSize % in radians
        maxOffset % in radians
        minOffset % in radians
        
        radius % in pixels???
    end
    
    properties (Dependent)       
        backgroundIntensityRGB
        peakIntensityRGB
        frequenciesRGB
    end
    
    methods
        function value = get.backgroundIntensityRGB(obj)
            value = [obj.backgroundIntensityR obj.backgroundIntensityG obj.backgroundIntensityB];
        end
        
        function value = get.peakIntensityRGB(obj)
            value = [obj.peakIntensityR obj.peakIntensityG obj.peakIntensityB];
        end
        
        function value = get.frequenciesRGB(obj)
            value = [obj.frequencyR obj.frequencyG obj.frequencyB];
        end
    end
    
    methods (Static)
        function parameters = DebugExample()
            parameters = SConePsychophysics.StimulusGenerators.Flicker.Parameters();
            parameters.backgroundIntensityR = 128;
            parameters.peakIntensityR = 255;
            
            parameters.backgroundIntensityG = 128;
            parameters.peakIntensityG = 255;
            
            parameters.backgroundIntensityB = 128;
            parameters.peakIntensityB = 255;
            
            parameters.frequencyR = 8;
            parameters.frequencyG = 8;
            parameters.frequencyB = 8;
            
            parameters.offsetStepSize = 0.01;
            parameters.maxOffset = 3;
            parameters.minOffset = -3;
            parameters.radius = 100;
        end
        
        function parameters = StockmanExample()
            parameters = SConePsychophysics.StimulusGenerators.Flicker.Parameters();
            parameters.backgroundIntensityR = 128;
            parameters.peakIntensityR = 255;
            
            parameters.backgroundIntensityG = 128;
            parameters.peakIntensityG = 255;
            
            parameters.backgroundIntensityB = 128;
            parameters.peakIntensityB = 255;
            
            parameters.frequencyR = 40;
            parameters.frequencyG = 40;
            parameters.frequencyB = 40.5;
            
            parameters.offsetStepSize = 0.01;
            parameters.maxOffset = 3;
            parameters.minOffset = -3;
            parameters.radius = 100;
        end
    end
end