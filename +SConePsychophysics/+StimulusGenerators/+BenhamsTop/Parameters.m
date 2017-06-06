classdef Parameters < SConePsychophysics.Utils.Parameters
    properties
        % intensity of background, a 3 element vector
        backgroundIntensities
        % intensity of the Benham's Top dark components, a 3 element vector
        darkIntensities
        
        % frequency (in Hz) at which the top will spin
        frequency
        
        % the step size when the offset is incremented/decremented (in
        % radians)
        offsetStepSize
        % max and min allowable offsets (in radians)
        maxOffset
        minOffset
        
        % radius of the top (in pixels)
        radius
        % number of arc groups in the top
        numArcGroups
        % number of arcs in each of the group (a vector with
        % numArcGroups elements)
        numArcsInGroups
        % theta ranges for each of the arc groups (a cell array with
        % numArcGroups elements, where each element is a 2 element vector
        % contain: [theta_start theta_end] for the given arc group)
        arcGroupThetas
        % thickness of each arc (in units of fraction of top radius)
        arcThickness
        % margin between arcs (in units of fraction of top radius)
        arcMargin
        % radius (in units of fraction of top radius) of the first arc
        startArcRadius
        
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
    
    % a static method that provides an example of how to define a parameter
    % set
    methods (Static)
        function parameters = DebugExample()
            parameters = SConePsychophysics.StimulusGenerators.BenhamsTop.Parameters();
            parameters.backgroundIntensities = [0.8 0.8 0.8];
            parameters.darkIntensities = [0 0 0];
            parameters.frequency = 1;
            parameters.offsetStepSize = 0.01;
            parameters.maxOffset = 0.3;
            parameters.minOffset = -0.3;
            parameters.radius = 100;
            parameters.numArcGroups = 3;
            parameters.numArcsInGroups = [4 3 3];
            parameters.arcGroupThetas = {[0 pi / 3], [(pi / 3) (2 * pi / 3)], [(2 * pi / 3) pi]};
            parameters.arcThickness = 0.04;
            parameters.arcMargin = 0.04;
            parameters.startArcRadius = 0.18;
            parameters.colorSpace = SConePsychophysics.Constants.COLOR_SPACE_LMS;
        end
    end
end