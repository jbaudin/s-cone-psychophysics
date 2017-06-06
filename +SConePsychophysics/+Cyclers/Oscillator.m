% A cycler subclass that oscillates the different stimulus channels within
% a circular disc and allows for the modulation of the phase offset of the
% 3rd channel.  This is useful for implementing stimuli such as in the
% Stockman, 1993 beat frequency experiment.

% The Cycler parent class defines a stimulusComponents property.  For this
% subclass, this needs to be a map where the keys are offsets and the
% values are the size of the 3rd channel phase offset (in radians) for that
% given offset

classdef Oscillator < SConePsychophysics.Cyclers.Cycler    
    properties
        factorsInSine
        shapeRectangles
        modulationAmplitudes
    end
    
    properties (Dependent)
        currColor
        currPhaseOffsets
    end
    
    methods
        function obj = Oscillator(hardwareParameters, stimulusParameters, stimulusComponents)
            % call superclass constructor
           obj = obj@SConePsychophysics.Cyclers.Cycler(hardwareParameters, stimulusParameters, stimulusComponents);
           
           % compute some values that will be used during stimulus
           % construction
           obj.ComputeShapeRectangles();
           obj.factorsInSine = 2 * pi * obj.stimulusParameters.frequencies;
           obj.modulationAmplitudes = ...
               obj.stimulusParameters.peakIntensities - obj.stimulusParameters.backgroundIntensities;
        end
        
        % calculate the rectangles in which the circular disc will be
        % displayed (this varies based on whether or not frames are being
        % rendered in quadrants)
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
        
        % draw in each of the four quadrants (each one displaying a frame
        % advanced by 1/4 of the frame period relative to the last one)
        function DrawInQuadrants(obj, frameTime)
            frameTimes = obj.CalculateQuadrantFrameTimes(frameTime);
            shapeColors = obj.CalculateShapeColors(frameTimes);
            for i = 1:4
                obj.DrawShape(obj.shapeRectangles{i}, shapeColors{i})
            end
        end
        
        % draw one single frame in the center of the screen
        function DrawEntireScreen(obj, frameTime)
            obj.DrawShape(obj.shapeRectangles, obj.CalculateShapeColor(frameTime));
        end
        
        % draw a disc in the specified rectangle with the specified color
        function DrawShape(obj, rectangle, shapeColor)
            Screen('FillOval', obj.hardwareParameters.window, shapeColor, rectangle);
        end
        
        % get the color of multiple discs at the specified frame times,
        % return a cell array of shape colors
        function shapeColors = CalculateShapeColors(obj, frameTimes)
            shapeColors = arrayfun(@(x) obj.CalculateShapeColor(x), frameTimes, 'UniformOutput', false);
        end
        
        % calculate the color of a single disc in RGB space
        function shapeColorRGBSpace = CalculateShapeColor(obj, frameTime)
           shapeColorStimulusSpace = obj.stimulusParameters.backgroundIntensities + obj.modulationAmplitudes .* ...
               sin(obj.factorsInSine * frameTime + obj.currPhaseOffsets);
           shapeColorRGBSpace = ...
               SConePsychophysics.Constants.COLOR_SPACE_PROJECTION_MATRICES(obj.stimulusParameters.colorSpace) ...
               * shapeColorStimulusSpace';
           shapeColorRGBSpace = shapeColorRGBSpace';
        end
        
        % once the cycler is done cycling, this method can be called to
        % compile the results; it can also be modified to change which
        % results are compiled
        function results = CompileResults(obj)
            results = SConePsychophysics.Utils.Results();
            offsetInRadians = obj.currOffset * obj.stimulusParameters.offsetStepSize;
            offsetInSeconds = (offsetInRadians/ (2 * pi)) / obj.stimulusParameters.frequencies(3);
            results.Add('s cone offset in radians', offsetInRadians);
            results.Add('blue channel frequency', obj.stimulusParameters.frequencies(3));
            results.Add('offset in seconds', offsetInSeconds);
            results.Add('offset in milliseconds',1000 * offsetInSeconds);
        end
        
        % return a 3 element vector of phase offsets, one for each channel
        function value = get.currPhaseOffsets(obj)
            value = [0 0 obj.stimulusComponents(obj.currOffset)];
        end
    end
end