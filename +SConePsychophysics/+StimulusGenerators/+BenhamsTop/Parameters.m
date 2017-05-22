classdef Parameters < SConePsychophysics.Utils.Parameters
    properties
        backgroundIntensity
        darkIntensity
        
        frequency % in Hz
        
        offsetStepSize % in radians
        maxOffset % in radians
        minOffset %in radians
        
        radius % in pixels???
        numArcGroups
        numArcsInGroups
        arcGroupThetas
        arcThickness
        arcMargin
        startArcRadius
    end
    
    methods (Static)
        function parameters = DebugExample()
            parameters = SConePsychophysics.StimulusGenerators.BenhamsTop.Parameters();
            parameters.backgroundIntensity = 0.8;
            parameters.darkIntensity = 0;
            parameters.frequency = 1;
            parameters.offsetStepSize = 0.1;
            parameters.maxOffset = 3;
            parameters.minOffset = -3;
            parameters.radius = 200;
            parameters.numArcGroups = 3;
            parameters.numArcsInGroups = [4 3 3];
            parameters.arcGroupThetas = {[0 pi / 3], [(pi / 3) (2 * pi / 3)], [(2 * pi / 3) pi]};
            parameters.arcThickness = 0.04;
            parameters.arcMargin = 0.04;
            parameters.startArcRadius = 0.18;
        end
    end
end