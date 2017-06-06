% A cycler subclass that spins a given frame around in circles.  As the
% offset is changed, a different frame is then spun.  An example of
% something that this is useful for is Benhams top.  If all of the top
% frames are precomputed (this drastically improves the smoothness of the
% display), then each offset will simply refer to a frame with a slightly
% different S cone phase offset.  This Spinner will spin a given frame
% until the user specifies a new offset, after which, it will begin
% spinning another frame.  

% The Cycler parent class defines a stimulusComponents property.  For this
% subclass, this needs to a map where the keys are offsets and the values
% are arrays for the frames, of size [h, w, 3].

classdef Spinner < SConePsychophysics.Cyclers.Cycler
    properties
        rotationPeriod
        textureRectangles
        currTexture
    end
    
    properties (Dependent)
        currFrame
    end
    
    methods
        function obj = Spinner(hardwareParameters, stimulusParameters, stimulusComponents)
            % call superclass constructor
            obj = obj@SConePsychophysics.Cyclers.Cycler(hardwareParameters, stimulusParameters, stimulusComponents);
            
            % compute some values that will be used in stimulus
            % construction
            obj.ComputeTextureRectangles();
            obj.rotationPeriod = 1 / obj.stimulusParameters.frequency;
            obj.UpdateTexture();
        end
        
        % calculate the rectangles in which to display the frames (varies
        % based on whether or not rendering in quadrants
        function ComputeTextureRectangles(obj)
            width = obj.hardwareParameters.width;
            height = obj.hardwareParameters.height;
            
            if obj.hardwareParameters.renderInQuadrants
                baseRectangle = CenterRectOnPoint( ...
                    obj.DetermineStimulusRectangle(), width / 4, height / 4);
                obj.textureRectangles = cellfun(@(x) baseRectangle + x, ...
                    {[0 0 0 0], ...
                    [(width / 2) 0 (width / 2) 0], ...
                    [0 (height / 2) 0 (height / 2)], ...
                    [(width / 2) (height / 2) (width / 2) (height / 2)]}, ...
                    'UniformOutput', false);
            else
                obj.textureRectangles = CenterRectOnPoint( ...
                    obj.DetermineStimulusRectangle(), ...
                    obj.hardwareParameters.width / 2, obj.hardwareParameters.height / 2);
            end
        end
        
        % draws a texture in each of the four quadrants (each one
        % displaying a frame advanced by 1/4 of the frame period relative
        % to the last one)
        function DrawInQuadrants(obj, frameTime)
            frameTimes = obj.CalculateQuadrantFrameTimes(frameTime);
            rotations = obj.CalculateTextureRotations(frameTimes);
            for i = 1:4
                obj.DrawTexture(obj.textureRectangles{i}, rotations(i));
            end
        end
        
        % draw one single texture in the center of the screen
        function DrawEntireScreen(obj, frameTime)
            rotation = obj.CalculateTextureRotations(frameTime);
            obj.DrawTexture(obj.textureRectangles, rotation);
        end
        
        % draw a texture with a specified center location and a specified
        % rotation
        function DrawTexture(obj, center, rotation)
            Screen('DrawTexture', ...
                obj.hardwareParameters.window, ...
                obj.currTexture, ...
                [], ...
                center, ...
                rotation, ...
                [], [], [], [], []);
        end
        
        % calculates the rotation of a frame given the time of the frame's
        % presentation
        function rotations = CalculateTextureRotations(obj, frameTimes)
            rotations = mod(frameTimes, obj.rotationPeriod) * 360 / obj.rotationPeriod;
        end
        
        % frames are displayed as rotated Psychtoolbox textures; once a new
        % frame (for a new offset) is being used, create a new texture
        function UpdateTexture(obj)
            obj.currTexture = Screen('MakeTexture', obj.hardwareParameters.window, obj.currFrame, [], [], 2);
        end
        
        % add to the superclass IncrementOffset method by also updating the
        % texture
        function IncrementOffset(obj)
            IncrementOffset@SConePsychophysics.Cyclers.Cycler(obj);
            obj.UpdateTexture();
        end
        
        % add to the superclass DecrementOffset method by also updating the
        % texture
        function DecrementOffset(obj)
            DecrementOffset@SConePsychophysics.Cyclers.Cycler(obj);
            obj.UpdateTexture();
        end
        
        % once the cycler is done cycling, this method can be called to
        % compile the results; it can also be modified to change which
        % results are compiled
        function results = CompileResults(obj)
            results = SConePsychophysics.Utils.Results();
            offsetInRadians = obj.currOffset * obj.stimulusParameters.offsetStepSize;
            offsetInSeconds = (offsetInRadians/ (2 * pi)) / obj.stimulusParameters.frequency;
            results.Add('offset in radians', offsetInRadians);
            results.Add('frequency', obj.stimulusParameters.frequency);
            results.Add('offset in seconds', offsetInSeconds);
            results.Add('offset in milliseconds',1000 * offsetInSeconds);
        end
        
        % calculate the value of the currFrame depend value by looking up
        % the frame in the stimulusComponents map using the current offset
        function value = get.currFrame(obj)
            value = obj.stimulusComponents(obj.currOffset);
        end
    end
end