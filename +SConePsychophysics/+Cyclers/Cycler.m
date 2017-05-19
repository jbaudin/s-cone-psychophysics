classdef Cycler < handle
    properties
        hardwareParameters
        stimulusParameters
        stimulusComponents
    end
    
    properties (Access = protected)
        currOffset
        offsetMin
        offsetMax
        
        continueCycling
        drawTextureFxn
    end
    
    methods (Abstract)
        % this may be the only thing that needs to be overriden in
        % subclasses ...
        % should return the frame and a rotation to use
        DrawTextureInQuadrants(obj, frameNum)
        DrawTextureEntireScreen(obj, frameNum)
    end
    
    methods
        function obj = Cycler(hardwareParameters, stimulusParameters, stimulusComponents)
            obj.hardwareParameters = hardwareParameters;
            obj.stimulusComponents = stimulusComponents;
            obj.stimulusParameters = stimulusParameters;
            obj.currOffset = 0;
            obj.offsetMax = floor(stimulusParameters.maxOffset / stimulusParameters.offsetStepSize);
            obj.offsetMin = ceil(stimulusParameters.minOffset / stimulusParameters.offsetStepSize);
            obj.continueCycling = true;
            
            if obj.hardwareParameters.renderInQuadrants
                obj.drawTextureFxn = @(frameNum) obj.DrawTextureInQuadrants(frameNum);
            else
                obj.drawTextureFxn = @(frameNum) obj.DrawTextureEntireScreen(frameNum);
            end
        end
        
        function rect = DetermineStimulusRectangle(obj)
            sideLength = 2 * obj.stimulusParameters.radius + 1;
            rect = [0 0 sideLength sideLength];
        end
        
        function IncrementOffset(obj)
            obj.currOffset = min(obj.currOffset + 1, obj.offsetMax);
        end
        
        function DecrementOffset(obj)
            obj.currOffset = max(obj.currOffset - 1, obj.offsetMin);
        end
        
        function DisplayFrame(obj, frameNumber)
            % call the appropriate draw texture method (defined in
            % constructor)
            obj.drawTextureFxn(obj.FramesToTime(frameNumber));
            
            % flip the image from the buffer to the front (i.e., display
            % the texture that was just created)
            Screen('Flip', obj.hardwareParameters.window);
        end
        
        function frameTimes = CalculateQuadrantFrameTimes(obj, frameTime)
            frameTimes = frameTime + ((0:3) / 4) * obj.hardwareParameters.theoreticalFrameDuration;
        end
        
        function frames = TimeToFrames(obj, time)
            frames = time * obj.hardwareParameters.theoreticalRefreshRate;
        end
        
        function time = FramesToTime(obj, frames)
            time = frames / obj.hardwareParameters.theoreticalRefreshRate;
        end
        
        function tf = ToContinueCycling(obj)
            tf = obj.continueCycling;
        end
        
        function StopCycling(obj)
            obj.continueCycling = false;
        end
    end
end