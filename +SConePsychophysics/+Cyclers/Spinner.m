classdef Spinner < SConePsychophysics.Cyclers.Cycler
    % this cycler needs a stimulusComponent that is a map of 3d arrays
    % (each providing the basis for a texture that can be rotated)
    
    % stimulusParameters must have the following properties:
    %       - frequency
    properties
        rotationPeriod
        textureCenters
        currTexture
    end
    
    properties (Dependent)
        currFrame
    end
    
    methods
        function obj = Spinner(hardwareParameters, stimulusParameters, stimulusComponents)
            obj = obj@SConePsychophysics.Cyclers.Cycler(hardwareParameters, stimulusParameters, stimulusComponents);

            obj.ComputeTextureCentersCenterOffsets();
            obj.rotationPeriod = 1 / obj.stimulusParameters.frequency;
            obj.UpdateTexture();
        end
        
        function ComputeTextureCentersCenterOffsets(obj)
            width = obj.hardwareParameters.width;
            height = obj.hardwareParameters.height;
            
            if obj.hardwareParameters.renderInQuadrants
                baseCenter = CenterRectOnPoint( ...
                    obj.DetermineStimulusRectangle(), ...
                    obj.hardwareParameters.width / 4, obj.hardwareParameters.height / 4);
                obj.textureCenters = cellfun(@(x) baseCenter + x, ...
                    {[0 0 0 0], ...
                    [(width / 2) 0 (width / 2) 0], ...
                    [0 (height / 2) 0 (height / 2)], ...
                    [(width / 2) (height / 2) (width / 2) (height / 2)]}, ...
                    'UniformOutput', false);
            else
                obj.textureCenters = CenterRectOnPoint( ...
                    obj.DetermineStimulusRectangle(), ...
                    obj.hardwareParameters.width / 2, obj.hardwareParameters.height / 2);
            end
        end
        
        % implementing the abstract methods for drawing textures
        function DrawTextureInQuadrants(obj, frameTime)
            frameTimes = obj.CalculateQuadrantFrameTimes(frameTime);
            rotations = obj.CalculateTextureRotations(frameTimes);
            for i = 1:4
                obj.DrawTexture(obj.textureCenters{i}, rotations(i));
            end
        end
        
        function DrawTextureEntireScreen(obj, frameTime)
            rotation = obj.CalculateTextureRotations(frameTime);
            obj.DrawTexture(obj.textureCenters, rotation);
        end
        
        function DrawTexture(obj, center, rotation)
            Screen('DrawTexture', ...
                obj.hardwareParameters.window, ...
                obj.currTexture, ...
                [], ...
                center, ...
                rotation, ...
                [], [], [], [], []);
        end
        
        function rotations = CalculateTextureRotations(obj, frameTimes)
            rotations = mod(frameTimes, obj.rotationPeriod) * 360 / obj.rotationPeriod;
        end
        
        function UpdateTexture(obj)
            obj.currTexture = Screen('MakeTexture', obj.hardwareParameters.window, obj.currFrame, [], [], 2);
        end
        
        function IncrementOffset(obj)
            IncrementOffset@SConePsychophysics.Cyclers.Cycler(obj);
            obj.UpdateTexture();
        end
        
        function DecrementOffset(obj)
            DecrementOffset@SConePsychophysics.Cyclers.Cycler(obj);
            obj.UpdateTexture();
        end
        
        function value = get.currFrame(obj)
            value = obj.stimulusComponents(obj.currOffset);
            disp(max(value(:)));
        end
    end
end