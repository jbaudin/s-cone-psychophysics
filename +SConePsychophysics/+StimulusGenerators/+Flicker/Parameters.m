classdef Parameters < SConePsychophysics.Utils.Parameters
    properties
        % intensity of background, a 3 element vector, one for each
        % stimulus dimension
        backgroundIntensities
        % max intensity of oscillation peaks, one for each stimulus
        % dimension
        peakIntensities
        
        % frequencies of oscillation, one for each stimulus dimension
        frequencies
        
        % step size for when the offset is incremented/decememented (in
        % radians)
        offsetStepSize
        % max and min allowable offsets (in radians)
        maxOffset
        minOffset
        
        % radius of the disc (in pixels)
        radius
        
        % center of the spot 
        centerX = 0
        centerY = 0
        
        % the color space in which the stimulus is specified (must be one
        % of the color spaces defined in the SConePsychophysics.Constants
        % file, such as SConePsychophysics.Constants.COLOR_SPACE_RGB)
        colorSpace
    end
    
    properties (Dependent)
        % matrix that transforms from stimulus space to monitor space
        % (doesn't need to be specified because it can be determined based
        % on the value of colorSpace)
        stimulusSpaceToMonitorSpaceMatrix
        % the background intensity value in monitor space (calculated using
        % the transformation matrix)
        backgroundIntensityMonitorSpace
    end
    
    % methods to compute the dependent properties
    methods
        function value = get.stimulusSpaceToMonitorSpaceMatrix(obj)
            value = SConePsychophysics.Constants.COLOR_SPACE_PROJECTION_MATRICES(obj.colorSpace);
        end
        
        function value = get.backgroundIntensityMonitorSpace(obj)
            value = obj.stimulusSpaceToMonitorSpaceMatrix * reshape(obj.backgroundIntensities, [3 1]);
        end
    end
    
    % some static methods that provide examples of how to define parameter
    % sets
    methods (Static)
        function parameters = DebugExample()
            parameters = SConePsychophysics.StimulusGenerators.Flicker.Parameters();
            parameters.backgroundIntensities = [0.5 0.5 0.5];
            parameters.peakIntensities = [0.6 0.6 1];
            parameters.frequencies = [15 15 15];
            
            parameters.offsetStepSize = 0.1;
            parameters.maxOffset = 3;
            parameters.minOffset = -3;
            parameters.radius = 100;
            
            parameters.centerX = 0;
            parameters.centerY = 0;
            
            parameters.colorSpace = SConePsychophysics.Constants.COLOR_SPACE_LMS;
        end
        
        function parameters = StockmanExample()
            parameters = SConePsychophysics.StimulusGenerators.Flicker.Parameters();
            parameters.backgroundIntensities = [0.5 0.5 0.5];
            parameters.peakIntensities = [1 1 1];
            parameters.frequencies = [40 40 40.5];
            
            parameters.offsetStepSize = 0.1;
            parameters.maxOffset = 3;
            parameters.minOffset = -3;
            parameters.radius = 100;
            
            parameters.centerX = 0;
            parameters.centerY = 0;
            
            parameters.colorSpace = SConePsychophysics.Constants.COLOR_SPACE_LMS;
        end
    end
end