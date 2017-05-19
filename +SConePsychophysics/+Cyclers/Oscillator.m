classdef Oscillator < SConePsychophysics.Cyclers.Cycler
    % this cycler requires stimulus components as follows:
    % stimulus components will be a matrix that will define
    % the stimulus to show - each of them will be scaled by a sinusoid for
    % each frame generation
    
    % require stimulus parameters:
    %       - step size: in units of seconds - defines the incremental
    %       steps used to advance the s cone signal ahead of the others
    %       - frequency - this will be the frequency of the oscillating
    %       stimulus
    
    properties
        factorInSine
        shapeRectangles
        modulationAmplitude
    end
    
    properties (Dependent)
        currColor
        currPhaseOffsets
    end
    
    methods
        function obj = Oscillator(hardwareParameters, stimulusParameters, stimulusComponents)
            obj = obj@SConePsychophysics.Cyclers.Cycler(hardwareParameters, stimulusParameters, stimulusComponents);
            
            obj.ComputeShapeRectangles();
            obj.factorInSine = 2 * pi * obj.stimulusParameters.frequency;
            obj.modulationAmplitude = obj.stimulusParameters.peakIntensity - obj.stimulusParameters.backgroundIntensity;
        end
        
        function ComputeShapeRectangles(obj)
            hwParams = obj.hardwareParameters;

            stimulusRectangle = obj.DetermineStimulusRectangle();
            
            if obj.hardwareParameters.renderInQuadrants
                width = hwParams.width;
                height = hwParams.height;
                
                baseRectangle = CenterRectOnPoint(obj.DetermineStimulusRectangle(), width / 4, height / 4);
                obj.shapeRectangles = cellfun(@(x) baseRectangle + x, ...
                    {[0 0 0 0], ...
                    [(width / 2) 0 (width / 2) 0], ...
                    [0 (height / 2) 0 (height / 2)], ...
                    [(width / 2) (height / 2) (width / 2) (height / 2)]}, ...
                    'UniformOutput', false);
            else
                screenRectangle = [0 0 hwParams.frameWidth hwParams.frameHeight];
                obj.shapeRectangles = CenterRect(stimulusRectangle, screenRectangle);
            end
        end
        
        function DrawTextureInQuadrants(obj, frameTime)
            frameTimes = obj.CalculateQuadrantFrameTimes(frameTime);
            shapeColors = obj.CalculateShapeColors(frameTimes);
            for i = 1:4
                obj.DrawShape(obj.shapeRectangles{i}, shapeColors{i})
            end
        end
        
        function DrawTextureEntireScreen(obj, frameTime)
            obj.DrawShape(obj.shapeRectangles, obj.CalculateShapeColor(frameTime));
        end
        
        function DrawShape(obj, rectangle, shapeColor)
            Screen('FillOval', obj.hardwareParameters.window, shapeColor, rectangle);
        end
        
        function shapeColors = CalculateShapeColors(obj, frameTimes)
            shapeColors = arrayfun(@(x) obj.CalculateShapeColor(x), frameTimes, 'UniformOutput', false);
        end
        
        function shapeColor = CalculateShapeColor(obj, frameTime)
            shapeColor = obj.stimulusParameters.backgroundIntensity + obj.modulationAmplitude * ...
                arrayfun(@(x) sin(obj.factorInSine * frameTime + x), obj.currPhaseOffsets);
        end
        
        function value = get.currPhaseOffsets(obj)
            value = [0 0 obj.stimulusComponents(obj.currOffset)];
        end
    end
end